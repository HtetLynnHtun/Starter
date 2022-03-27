//
//  ActorResultObject.swift
//  Starter
//
//  Created by kira on 27/03/2022.
//

import Foundation
import RealmSwift

class ActorResultObject: Object {
    
    @Persisted(primaryKey: true)
    var id: Int
    
    @Persisted
    var biography: String?
    
    @Persisted
    var birthday: String?
    
    @Persisted
    var homepage: String?
    
    @Persisted
    var knownForDepartment: String?
    
    @Persisted
    var name: String?
    
    @Persisted
    var popularity: Double?
    
    @Persisted
    var profilePath: String?
    
    @Persisted
    var credits: List<MovieResultObject>
}
