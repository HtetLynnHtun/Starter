//
//  MovieRepositoryRealm.swift
//  Starter
//
//  Created by kira on 27/03/2022.
//

import Foundation

class MovieRepositoryRealm: BaseRepository, MovieRepository {
    
    static let shared = MovieRepositoryRealm()
    
    private override init() {
        super.init()
    }
    
    func saveList(data: [MovieResult], type: MovieSeriesGroupType) {
        
        let movieObjects: [MovieResultObject] = data.map { movieResult in
            var movieObject: MovieResultObject!
            if let savedObject = self.realm.object(ofType: MovieResultObject.self, forPrimaryKey: movieResult.id ?? -1) {
                movieObject = savedObject
            } else {
                movieObject = movieResult.toMovieResultObject()
            }
            return movieObject
        }
        
        do {
            try self.realm.write {
                switch type {
                case .upcomingMovies:
                    movieObjects.forEach { $0.isUpcoming = true }
                case .popularMovies:
                    movieObjects.forEach { $0.isPopular = true }
                case .topRatedMovies:
                    movieObjects.forEach { $0.isTopRated = true }
                case .popularSeries:
                    movieObjects.forEach {
                        $0.isPopular = true
                        $0.isSeries = true
                    }
                }
                self.realm.add(movieObjects, update: .modified)
            }
        } catch {
            print("\(#function) \(error.localizedDescription)")
        }
        
    }
    
    func saveDetails(data: MovieResult) {
        let newObject = data.toMovieResultObject()
        if let savedObject = self.realm.object(ofType: MovieResultObject.self, forPrimaryKey: data.id ?? -1) {
            newObject.genreIDS.append(objectsIn: savedObject.genreIDS)
        }
        
        do {
            try self.realm.write({
                self.realm.add(newObject, update: .modified)
            })
        } catch {
            print("\(#function) \(error.localizedDescription)")
        }
    }
    
    func getDetails(of id: Int, completion: @escaping (MovieResult?) -> Void) {
        let object = self.realm.object(ofType: MovieResultObject.self, forPrimaryKey: id)
        completion(object?.toMovieResult())
    }
    
    func saveMovieCredits(of id: Int, data: CreditsResponse) {
        if let movieObject = self.realm.object(ofType: MovieResultObject.self, forPrimaryKey: id) {
            if let actorObjects = data.cast?.map({ cast in
                cast.toActorResult().toActorResultObject()
            }) {
                actorObjects.forEach { object in
                    do {
                        try self.realm.write({
                            self.realm.add(object, update: .modified)
                            movieObject.casts.append(object)
                        })
                    } catch {
                        print("\(#function) \(error)")
                    }
                }
                
            }
        }
        
    }
    
    func getMovieCredits(of id: Int, completion: @escaping ([ActorResult]) -> Void) {
        if let movieObject = self.realm.object(ofType: MovieResultObject.self, forPrimaryKey: id) {
            let data: [ActorResult] = movieObject.casts.map { $0.toActorResult() }
            completion(data)
        } else {
            completion([])
        }
    }
    
    func saveSimilarMovies(of id: Int, data: MovieListResponse) {
        if let movieObject = self.realm.object(ofType: MovieResultObject.self, forPrimaryKey: id) {
            if let similarMovieObjects = data.results?.map({ $0.toMovieResultObject() }) {
                similarMovieObjects.forEach { object in
                    do {
                        try self.realm.write({
                            if let savedObject = self.realm.object(ofType: MovieResultObject.self, forPrimaryKey: object.id) {
                                movieObject.similarContents.append(savedObject)
                            } else {
                                self.realm.add(object, update: .modified)
                                movieObject.similarContents.append(object)
                            }
                        })
                    } catch {
                        print("\(#function) \(error)")
                    }
                }
            }
        }
    }
    
    func getSimilarMovies(of id: Int, completion: @escaping ([MovieResult]) -> Void) {
        if let movieObject = self.realm.object(ofType: MovieResultObject.self, forPrimaryKey: id) {
            let data: [MovieResult] = movieObject.similarContents.map({ $0.toMovieResult() })
            completion(data)
        } else {
            completion([])
        }
    }
    
}
