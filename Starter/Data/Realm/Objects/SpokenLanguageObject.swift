//
//  SpokenLanguageObject.swift
//  Starter
//
//  Created by kira on 27/03/2022.
//

import Foundation
import RealmSwift

class SpokenLanguageObject: Object {
    
    @Persisted(primaryKey: true)
    var name: String
    
    @Persisted
    var englishName: String?
    
    @Persisted
    var iso639_1: String?
    
    func toSpokenLanguage() -> SpokenLanguage {
        return SpokenLanguage(englishName: englishName, iso639_1: iso639_1, name: name)
    }
}
