//
//  MovieRepositoryRealm.swift
//  Starter
//
//  Created by kira on 27/03/2022.
//

import Foundation

class MovieRepositoryRealm: BaseRepository, MovieRepository {
    
    func saveList(data: [MovieResult], type: MovieSeriesGroupType) {
        if let groupObject = self.realm.objects(MovieGroupTypeObject.self)
            .first(where: { object in
                object.name == type.rawValue
            }) {
            data.forEach { movieResult in
                let movieObject = MovieResultObject()
            }
            do {
                try self.realm.write({
                    self.realm.add
                })
            } catch {
                
            }
        } else {
            
        }
    }
    
    func saveDetails(data: MovieResult) {
        <#code#>
    }
    
    func getDetails(of id: Int, completion: @escaping (MovieResult?) -> Void) {
        <#code#>
    }
    
    func saveMovieCredits(of id: Int, data: CreditsResponse) {
        <#code#>
    }
    
    func getMovieCredits(of id: Int, completion: @escaping ([ActorResult]) -> Void) {
        <#code#>
    }
    
    func saveSimilarMovies(of id: Int, data: MovieListResponse) {
        <#code#>
    }
    
    func getSimilarMovies(of id: Int, completion: @escaping ([MovieResult]) -> Void) {
        <#code#>
    }
    
}
