//
//  BaseRepository.swift
//  Starter
//
//  Created by kira on 22/03/2022.
//

import Foundation
import RealmSwift

class BaseRepository: NSObject {
    let coreData = CoreDataStack.shared
    let realm = try! Realm()
    
    override init() {
        super.init()
        
        print("=======================")
        print("Realm file is at: \(realm.configuration.fileURL!.absoluteString)")
    }
}
