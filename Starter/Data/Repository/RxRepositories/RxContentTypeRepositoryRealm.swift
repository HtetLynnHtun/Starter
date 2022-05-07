//
//  RxContentTypeRepository.swift
//  Starter
//
//  Created by kira on 06/05/2022.
//

import Foundation
import RxSwift
import RxRealm

class RxContentTypeRepositoryRealm: BaseRepository {
    
    static let shared = RxContentTypeRepositoryRealm()
    
    private override init() {
        super.init()
    }
    
    func getMoviesOrSeries(type: MovieSeriesGroupType) -> Observable<[MovieResult]> {
        let objects = self.realm.objects(MovieResultObject.self)
        
        return Observable.collection(from: objects)
            .map { $0.toArray() }
            .map { $0.filter {
                switch type {
                case .upcomingMovies:
                    return $0.isUpcoming
                case .popularMovies:
                    return $0.isPopular && !$0.isSeries
                case .topRatedMovies:
                    return $0.isTopRated
                case .popularSeries:
                    return $0.isPopular && $0.isSeries
                }
            }.map { $0.toMovieResult() }
                    .sorted { first, second in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let firstDate = dateFormatter.date(from: first.releaseDate ?? "") ?? Date()
                        let secondDate = dateFormatter.date(from: second.releaseDate ?? "") ?? Date()
                        return firstDate.compare(secondDate) == .orderedDescending
                    }
            }
        
//        return Observable.create { observer in
//            var notificationToken: NotificationToken?
//            var movieObjects = [MovieResultObject]()
//
//            notificationToken = self.realm.objects(MovieResultObject.self)
//                .observe { change in
//                    switch change {
//                    case .initial(let objects):
//                        movieObjects = Array(objects)
//                    case .update(let objects, _, _, _):
//                        movieObjects = Array(objects)
//                    case .error(let error):
//                        observer.onError(error)
//                    }
//
//                    let results = movieObjects.filter {
//                        switch type {
//                        case .upcomingMovies:
//                            return $0.isUpcoming
//                        case .popularMovies:
//                            return $0.isPopular
//                        case .topRatedMovies:
//                            return $0.isTopRated
//                        case .popularSeries:
//                            return $0.isPopular && $0.isSeries
//                        }
//                    }.map { $0.toMovieResult() }
//
//                    observer.onNext(results)
//                }
//
//            return Disposables.create {
//                notificationToken?.invalidate()
//            }
//        }
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
