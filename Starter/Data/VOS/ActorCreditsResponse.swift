//
//  ActorCreditsResponse.swift
//  Starter
//
//  Created by kira on 15/03/2022.
//

import Foundation

struct ActorCreditsResponse: Codable {
    let results: [MovieResult]?
    let id: Int?
    
    enum CodingKeys: String, CodingKey {
        case results = "cast"
        case id
    }
}
