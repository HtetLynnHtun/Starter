//
//  GenreVO.swift
//  Starter
//
//  Created by kira on 09/02/2022.
//

import Foundation

class GenreVO {
    var name: String = "ACTION"
    var isSelected: Bool = false
    
    init(name: String, isSelected: Bool) {
        self.name = name
        self.isSelected = isSelected
    }
}
