//
//  GenreRepository.swift
//  Starter
//
//  Created by kira on 23/03/2022.
//

import Foundation

protocol GenreRepository {
    func get(completion: @escaping ([MovieGenre]) -> Void)
    func save(data: MovieGenreList)
}

class GenreRepositoryImpl: BaseRepository, GenreRepository {
    
    static let shared = GenreRepositoryImpl()
    
    private override init() { }
    
    func get(completion: @escaping ([MovieGenre]) -> Void) {
        let fetchRequest = GenreEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        do {
            let results = try coreData.context.fetch(fetchRequest)
            let items = results.map { entity in
                return GenreEntity.toMovieGenre(entity: entity)
            }
            completion(items)
        } catch {
            completion([MovieGenre]())
            print("\(#function) \(error.localizedDescription)")
        }
    }
    
    func save(data: MovieGenreList) {
//        data.genres.map { movieGenre in
//            let entity = GenreEntity(context: coreData.context)
//            entity.id = Int32(movieGenre.id)
//            entity.name = movieGenre.name
//        }
        let _ = data.genres.map { movieGenre in
            let entity = GenreEntity(context: coreData.context)
            entity.id = Int32(movieGenre.id)
            entity.name = movieGenre.name
        }
        
        coreData.saveContext()
    }
    
    
}
