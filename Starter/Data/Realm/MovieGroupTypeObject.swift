//
//  MovieGroupTypeObject.swift
//  Starter
//
//  Created by kira on 27/03/2022.
//

import Foundation
import RealmSwift

class MovieGroupTypeObject: Object {
    
    @Persisted
    var name: String
    
    @Persisted
    var movies: List<MovieResultObject>
}
