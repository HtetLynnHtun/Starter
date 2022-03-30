//
//  ContentTypeRepositoryRealm.swift
//  Starter
//
//  Created by kira on 27/03/2022.
//

import Foundation

class ContentTypeRepositoryRealm: BaseRepository {
    
    static let shared = ContentTypeRepositoryRealm()
    
    private override init() {
        super.init()
    }
    
    func getMoviesOrSeries(type: MovieSeriesGroupType, completion: @escaping ([MovieResult]) -> Void) {
        let objects = self.realm.objects(MovieResultObject.self)
            .filter {
                switch type {
                case .upcomingMovies:
                    return $0.isUpcoming
                case .popularMovies:
                    return $0.isPopular
                case .topRatedMovies:
                    return $0.isTopRated
                case .popularSeries:
                    return $0.isPopular && $0.isSeries
                }
            }
            
        
        let data: [MovieResult] = objects.map { $0.toMovieResult() }
        completion(data)
    }
    
    private var itemsPerPage = 20
    
    func getTopRatedMoviesTotalPages() -> Int {
        let count = self.realm.objects(MovieResultObject.self)
            .filter { $0.isTopRated }.count
        var totalPages = count / itemsPerPage
        if count % itemsPerPage != 0 {
            totalPages += 1
        }
        return totalPages
    }
    
    func isLastPage(_ page: Int) -> Bool {
        return page == getTopRatedMoviesTotalPages()
    }
    
    func getTopRatedMovies(page: Int, completion: @escaping ([MovieResult]) -> Void) {
        let objects = self.realm.objects(MovieResultObject.self)
            .filter { $0.isTopRated }
            .sorted { $0.voteAverage! > $1.voteAverage! }
        
        let startAt = (page * itemsPerPage) - itemsPerPage
        let endAt = startAt + itemsPerPage
        var data = [MovieResult]()
        
        if (isLastPage(page)) {
            data = objects.dropFirst(startAt).map { $0.toMovieResult() }
        } else {
            data = objects[startAt..<endAt].map { $0.toMovieResult() }
        }
        
        completion(data)
    }
    
}
