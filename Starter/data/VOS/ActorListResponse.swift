//
//  ActorListResponse.swift
//  Starter
//
//  Created by kira on 10/03/2022.
//

import Foundation

// MARK: - ActorListResponse
struct ActorListResponse: Codable {
    let page: Int?
    let results: [ActorResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - ActorResult
struct ActorResult: Codable {
    let adult: Bool?
    let gender, id: Int?
    let knownFor: [MovieResult]?
    let knownForDepartment: String?
    let name: String?
    let popularity: Double?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case name, popularity
        case profilePath = "profile_path"
    }
}

