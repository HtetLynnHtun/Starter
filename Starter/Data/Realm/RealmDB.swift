//
//  RealmDB.swift
//  Starter
//
//  Created by kira on 28/03/2022.
//

import Foundation
import RealmSwift

class RealmDB {
    static let shared = RealmDB()
    let realm = try! Realm()
    
    private init() {
        print("=======================")
        print("Realm file is at: \(realm.configuration.fileURL!.absoluteString)")
    }
}
