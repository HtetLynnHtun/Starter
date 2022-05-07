//
//  RxGenreRepositoryRealm.swift
//  Starter
//
//  Created by kira on 07/05/2022.
//

import Foundation
import RxSwift
import RxRealm

class RxGenreRepositoryRealm: BaseRepository {
    
    static let shared = RxGenreRepositoryRealm()
    private override init() {
        super.init()
    }
    
    func get() -> Observable<[MovieGenre]> {
        let objects = self.realm.objects(MovieGenreObject.self)
            .sorted(byKeyPath: "name", ascending: true)
        
        return Observable.collection(from: objects)
            .map { $0.toArray() }
            .map { $0.map { $0.toMovieGenre() } }
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
