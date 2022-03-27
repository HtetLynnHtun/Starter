//
//  SpokenLanguageEntityExtesnsions.swift
//  Starter
//
//  Created by kira on 24/03/2022.
//

import Foundation

extension SpokenLanguageEntity {
    static func toSpokenLanguage(entity: SpokenLanguageEntity) -> SpokenLanguage {
        return SpokenLanguage(englishName: entity.englishName, iso639_1: entity.iso3166_1, name: entity.name)
    }
}
