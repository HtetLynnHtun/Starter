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
    
    func toProductionCountry() -> ProductionCountry {
        return ProductionCountry(iso3166_1: iso3166_1, name: name)
    }
}
