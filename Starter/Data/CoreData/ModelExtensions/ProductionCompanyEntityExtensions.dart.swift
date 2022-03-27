//
//  ProductionCompanyEntityExtensions.dart.swift
//  Starter
//
//  Created by kira on 24/03/2022.
//

import Foundation

extension ProductionCompanyEntity {
    static func toProductionCompany(entity: ProductionCompanyEntity) -> ProductionCompany {
        return ProductionCompany(
            id: Int(entity.id),
            logoPath: entity.logoPath,
            name: entity.name,
            originCountry: entity.originCountry
        )
    }
}
