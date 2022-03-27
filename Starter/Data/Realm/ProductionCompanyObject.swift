//
//  ProductionCompanyObject.swift
//  Starter
//
//  Created by kira on 27/03/2022.
//

import Foundation
import RealmSwift

class ProductionCompanyObject: Object {
    
    @Persisted(primaryKey: true)
    var id: Int
    
    @Persisted
    var logoPath: String?
    
    @Persisted
    var name: String?
    
    @Persisted
    var originCountry: String?
    
}
