//
//  TrailersResponse.swift
//  Starter
//
//  Created by kira on 13/03/2022.
//

import Foundation

struct TrailersResponse: Codable {
    let id: Int?
    let results: [TrailerResult]?
}

struct TrailerResult: Codable {
    let key: String?
    let site: String?
}
