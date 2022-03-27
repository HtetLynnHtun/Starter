//
//  ContentTypeRepositoryRealm.swift
//  Starter
//
//  Created by kira on 27/03/2022.
//

import Foundation

class ContentTypeRepositoryRealm: BaseRepository {
    
    static let shared = ContentTypeRepositoryRealm()
    
    private var contentTypeMap = [String: MovieGroupTypeObject]()
    
    private override init() {
        super.init()
        initializeData()
    }
    
    private func initializeData() {
        let results = self.realm.objects(MovieGroupTypeObject.self)
        
        if results.isEmpty {
            MovieSeriesGroupType.allCases.forEach { group in
                save(name: group.rawValue)
            }
        } else {
            results.forEach { object in
                contentTypeMap[object.name] = object
            }
        }
        
    }

    @discardableResult
    func save(name: String) -> MovieGroupTypeObject {
        let object = MovieGroupTypeObject()
        object.name = name
        contentTypeMap[name] = object
        
        do {
            try self.realm.write({
                self.realm.add(object)
            })
        } catch {
            print("\(#function) \(error.localizedDescription)")
        }
        return object
    }
    
    func getMoviesOrSeries(type: MovieSeriesGroupType, completion: @escaping ([MovieResult]) -> Void) {
        let objects = self.realm.objects(MovieGroupTypeObject.self)
        if let object = objects.first(where: { obj in
            return obj.name == type.rawValue
        }) {
            let data: [MovieResult] = object.movies.map { movieObject in
                return movieObject.toMovieResult()
            }
            
            completion(data)
        } else {
            completion([])
        }
    }
    
//    func getBelongsToTypeEntity(type: MovieSeriesGroupType) -> BelongsToTypeEntity {
//
//    }
    
//    func getTopRatedMovies(page: Int, completion: @escaping ([MovieResult]) -> Void) {
//
//    }
//
//    func getTopRatedMoviesTotalPages(completion: @escaping (Int) -> Void) {
//
//    }
    
}
