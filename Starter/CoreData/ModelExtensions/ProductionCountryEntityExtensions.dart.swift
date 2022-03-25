//
//  ProductionCountryEntityExtensions.dart.swift
//  Starter
//
//  Created by kira on 24/03/2022.
//

import Foundation

extension ProductionCountryEntity {
    static func toProductionCountry(entity: ProductionCountryEntity) -> ProductionCountry {
        return ProductionCountry(iso3166_1: entity.iso3166_1, name: entity.name)
    }
}
