//
//  RxActorRepositoryRealm.swift
//  Starter
//
//  Created by kira on 21/05/2022.
//

import Foundation
import RxSwift

class RxActorRepositoryRealm: BaseRepository {
    
    static let shared = RxActorRepositoryRealm()
    
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
    
    func getByPage(of page: Int) -> Observable<[ActorResult]> {
        let objects = self.realm.objects(ActorResultObject.self)
            .sorted(byKeyPath: "popularity", ascending: false)
        
        return Observable.collection(from: objects)
            .map { $0.toArray() }
            .map { data in
                guard !data.isEmpty else {
                    return []
                }
                let startAt = (self.itemsPerPage * page) - self.itemsPerPage
                let endAt = startAt + self.itemsPerPage
                var results = [ActorResult]()
                
                if (self.isLastPage(page)) {
                    results = data.dropFirst((page - 1) * self.itemsPerPage).map { $0.toActorResult() }
                } else {
                    results = data[startAt..<endAt].map { $0.toActorResult() }
                }
                return results
            }
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
}
