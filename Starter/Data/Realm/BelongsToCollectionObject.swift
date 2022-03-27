//
//  BelongsToCollectionObject.swift
//  Starter
//
//  Created by kira on 27/03/2022.
//

import Foundation
import RealmSwift

class BelongsToCollectionObject: Object {
    
    @Persisted(primaryKey: true)
    var id: Int
    
    @Persisted
    var backdropPath: String?
    
    @Persisted
    var name: String?
    
    @Persisted
    var posterPath: String?
    
    @Persisted
    var movies: List<MovieResultObject>
    
    func toBelongsToCollection() -> BelongsToCollection {
        return BelongsToCollection(
            id: id,
            name: name,
            posterPath: posterPath,
            backdropPath: backdrop
        )
    }
}
