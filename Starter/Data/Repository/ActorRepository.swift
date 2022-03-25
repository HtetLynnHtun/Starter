//
//  ActorRepository.swift
//  Starter
//
//  Created by kira on 24/03/2022.
//

import Foundation

protocol ActorRepository {
    func saveAll(data: [ActorResult])
    func getByPage(of page: Int, completion: @escaping ([ActorResult]) -> Void)
    func saveDetails(data: ActorResult)
    func getDetails(of id: Int, completion: @escaping (ActorResult) -> Void)
    func saveCredits(of id: Int, data: [MovieResult])
    func getCredits(of id: Int, completion: @escaping ([MovieResult]) -> Void)
    func getTotalPages(completion: @escaping (Int) -> Void)
}

class ActorRepositoryImpl: BaseRepository, ActorRepository {
    static let shared = ActorRepositoryImpl()
    private override init() {
        super.init()
    }
    
    private let itemPerPage = 20
    
    func getTotalPages(completion: @escaping (Int) -> Void) {
        let fetchRequest = ActorEntity.fetchRequest()
        do {
            let count = try self.coreData.context.count(for: fetchRequest)
            var totalPages = count / itemPerPage
            if count % itemPerPage != 0 {
                totalPages += 1
            }
            completion(totalPages)
        } catch {
            print("\(#function) \(error.localizedDescription)")
            completion(0)
        }
    }
    
    func saveAll(data: [ActorResult]) {
        data.forEach({ actorResult in
            actorResult.toActorEntity(context: self.coreData.context)
        })
        
        self.coreData.saveContext()
    }
    
    func getByPage(of page: Int, completion: @escaping ([ActorResult]) -> Void) {
        let fetchRequest = ActorEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        fetchRequest.fetchLimit = itemPerPage
        fetchRequest.fetchOffset = (itemPerPage * page) - itemPerPage
        
        do {
            let results = try self.coreData.context.fetch(fetchRequest)
            let items = results.map { actorEntity in
                return ActorEntity.toActorResult(entity: actorEntity)
            }
            completion(items)
        } catch {
            completion([])
            print("\(#function) \(error.localizedDescription)")
        }
    }
    
    func saveDetails(data: ActorResult) {
        data.toActorEntity(context: self.coreData.context)
        self.coreData.saveContext()
    }
    
    func getDetails(of id: Int, completion: @escaping (ActorResult) -> Void) {
        let fetchRequest = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %d", "id", id)
        
        do {
            let results = try self.coreData.context.fetch(fetchRequest)
            if let entity = results.first {
                let data = ActorEntity.toActorResult(entity: entity)
                completion(data)
            }
        } catch {
            print("\(#function) \(error)")
        }
    }
    
    func saveCredits(of id: Int, data: [MovieResult]) {
        let fetchRequest = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %d", "id", id)
        
        do {
            let results = try self.coreData.context.fetch(fetchRequest)
            if let entity = results.first {
                data.forEach { movieResult in
                    let movieEntity = movieResult.toMovieEntity(context: self.coreData.context, groupType: nil)
                    entity.addToCredits(movieEntity)
                }
                self.coreData.saveContext()
            }
        } catch {
            print("\(#function) \(error.localizedDescription)")
        }
    }
    
    func getCredits(of id: Int, completion: @escaping ([MovieResult]) -> Void) {
        let fetchRequest = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %d", "id", id)
        
        do {
            let results = try self.coreData.context.fetch(fetchRequest)
            if let entity = results.first,
               let credits = entity.credits as? Set<MovieEntity> {
                let data = credits.map { movieEntity in
                    return MovieEntity.toMovieResult(entity: movieEntity)
                }.sorted { first, second in
                    return first.popularity! > second.popularity!
                }
                completion(data)
            }
        } catch {
            print("\(#function) \(error.localizedDescription)")
        }
    }
}
