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
    let realm = RealmDB.shared.realm
    
    override init() {
        super.init()
    }
}
