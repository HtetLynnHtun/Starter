//
//  BaseRepository.swift
//  Starter
//
//  Created by kira on 22/03/2022.
//

import Foundation

class BaseRepository: NSObject {
    let coreData = CoreDataStack.shared
    
    override init() {
        super.init()
    }
}
