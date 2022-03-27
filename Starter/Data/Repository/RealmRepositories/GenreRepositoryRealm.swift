//
//  GenreRepositoryRealm.swift
//  Starter
//
//  Created by kira on 27/03/2022.
//

import Foundation

class GenreRepositoryRealm: BaseRepository, GenreRepository {
    
    static let shared = GenreRepositoryRealm()
    private override init() {
        super.init()
    }
    
    func get(completion: @escaping ([MovieGenre]) -> Void) {
        let items: [MovieGenre] = self.realm.objects(MovieGenreObject.self)
            .sorted(byKeyPath: "name", ascending: true)
            .map { object in
                return object.toMovieGenre()
            }
        completion(items)
    }
    
    func save(data: MovieGenreList) {
        let objects = data.genres.map { movieGenre -> MovieGenreObject in
            let object = MovieGenreObject()
            object.id = movieGenre.id
            object.name = movieGenre.name
            
            return object
        }
        
        do {
            try self.realm.write({
                self.realm.add(objects, update: .modified)
            })
        } catch {
            print("\(#function) \(error.localizedDescription)")
        }
    }
    
}
