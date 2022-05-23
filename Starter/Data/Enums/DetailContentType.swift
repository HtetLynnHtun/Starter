//
//  DetailContentType.swift
//  Starter
//
//  Created by kira on 13/03/2022.
//

import Foundation

enum DetailContentType {
    case movie
    case series
    
    static func of(mediaType: String) -> DetailContentType {
        if (mediaType == "tv") {
            return series
        } else {
            return movie
        }
    }
}
