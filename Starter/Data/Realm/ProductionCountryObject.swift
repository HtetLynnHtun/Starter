//
//  ProductionCountryObject.swift
//  Starter
//
//  Created by kira on 27/03/2022.
//

import Foundation
import RealmSwift

class ProductionCountryObject: Object {
    
    @Persisted(primaryKey: true)
    var name: String
    
    @Persisted
    var iso3166_1: String?
    
}
