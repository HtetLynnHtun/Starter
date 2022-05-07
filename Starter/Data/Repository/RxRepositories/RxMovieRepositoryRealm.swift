//
//  RxMovieRepositoryRealm.swift
//  Starter
//
//  Created by kira on 06/05/2022.
//

import Foundation

class RxMovieRepositoryRealm: BaseRepository {
    
    static let shared = RxMovieRepositoryRealm()
    
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
            newObject.casts.append(objectsIn: savedObject.casts)
            newObject.similarContents.append(objectsIn: savedObject.similarContents)
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
            if var actors = data.cast {
                // filter out already-saved actors
                actors = actors.filter({ cast in
                    !movieObject.casts.contains { $0.id == cast.id! }
                })
                let objects = actors.map { cast -> ActorResultObject in
                    if let savedActor = self.realm.object(ofType: ActorResultObject.self, forPrimaryKey: cast.id!) {
                        return savedActor
                    } else {
                        return cast.toActorResultObject()
                    }
                }
                do {
                    try self.realm.write({
                        self.realm.add(objects, update: .modified)
                        movieObject.casts.append(objectsIn: objects)
                    })
                } catch {
                    print("\(#function) \(error.localizedDescription)")
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
            if var similarMovies = data.results {
                similarMovies = similarMovies.filter({ movie in
                    !movieObject.similarContents.contains { $0.id == movie.id! }
                })
                
                let objects = similarMovies.map { movie -> MovieResultObject in
                    if let savedMovie = self.realm.object(ofType: MovieResultObject.self, forPrimaryKey: movie.id!) {
                        return savedMovie
                    } else {
                        return movie.toMovieResultObject()
                    }
                }
                
                do {
                    try self.realm.write({
                        self.realm.add(objects, update: .modified)
                        movieObject.similarContents.append(objectsIn: objects)
                    })
                } catch {
                    print("\(#function) \(error.localizedDescription)")
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