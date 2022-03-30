//
//  ActorRepository.swift
//  Starter
//
//  Created by kira on 29/03/2022.
//

import Foundation

class ActorRepositoryRealm: BaseRepository {
    
    static let shared = ActorRepositoryRealm()
    private let itemsPerPage = 20
    
    private override init() {
        super.init()
    }
    
    func getTotalPages() -> Int {
        let count = self.realm.objects(ActorResultObject.self).count
        var totalPages = count / itemsPerPage
        if count % itemsPerPage != 0 {
            totalPages += 1
        }
        return totalPages
    }
    
    func isLastPage(_ page: Int) -> Bool {
        return page == getTotalPages()
    }
    
    func saveAll(data: [ActorResult]) {
        let actorObjects: [ActorResultObject] = data.map { actorResult in
            var actorObject: ActorResultObject!
            if let savedObject = self.realm.object(ofType: ActorResultObject.self, forPrimaryKey: actorResult.id ?? -1) {
                actorObject = savedObject
            } else {
                actorObject = actorResult.toActorResultObject()
            }
            return actorObject
        }
        
        do {
            try self.realm.write({
                self.realm.add(actorObjects, update: .modified)
            })
        } catch {
            print("\(#function) \(error.localizedDescription)")
        }
    }
    
    func getByPage(of page: Int, completion: @escaping ([ActorResult]) -> Void) {
        let objects = self.realm.objects(ActorResultObject.self)
            .sorted(byKeyPath: "popularity", ascending: false)
        
        let startAt = (itemsPerPage * page) - itemsPerPage
        let endAt = startAt + itemsPerPage
        var data = [ActorResult]()
        
        if (isLastPage(page)) {
            data = objects.dropFirst((page - 1) * itemsPerPage).map { $0.toActorResult() }
        } else {
            data = objects[startAt..<endAt].map { $0.toActorResult() }
        }
        
        completion(data)
    }
    
    func saveDetails(data: ActorResult) {
        let object = data.toActorResultObject()
        do {
            try self.realm.write({
                self.realm.add(object, update: .modified)
            })
        } catch {
            print("\(#function) \(error)")
        }
    }
    
    func getDetails(of id: Int, completion: @escaping (ActorResult) -> Void) {
        if let savedDetails = self.realm.object(ofType: ActorResultObject.self, forPrimaryKey: id) {
            completion(savedDetails.toActorResult())
        }
    }
    
    func saveCredits(of id: Int, data: [MovieResult]) {
        if let actorObject = self.realm.object(ofType: ActorResultObject.self, forPrimaryKey: id) {
            let movieObjects = data.map { $0.toMovieResultObject() }
            movieObjects.forEach { object in
                do {
                    try self.realm.write({
                        if let savedObject = self.realm.object(ofType: MovieResultObject.self, forPrimaryKey: object.id) {
                            actorObject.credits.append(savedObject)
                        } else {
                            actorObject.credits.append(object)
                        }
                    })
                } catch {
                    print("\(#function) \(error)")
                }
            }
        }
    }
    
    func getCredits(of id: Int, completion: @escaping ([MovieResult]) -> Void) {
        if let actorObject = self.realm.object(ofType: ActorResultObject.self, forPrimaryKey: id) {
            let data: [MovieResult] = actorObject.credits.map { $0.toMovieResult() }
            completion(data)
        } else {
            completion([])
        }
    }
    
}
