//
//  MovieGenreObject.swift
//  Starter
//
//  Created by kira on 27/03/2022.
//

import Foundation
import RealmSwift

class MovieGenreObject: Object {
    
    @Persisted(primaryKey: true)
    var id: Int
    
    @Persisted
    var name: String
    
}
