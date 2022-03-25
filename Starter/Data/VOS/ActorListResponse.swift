//
//  ActorListResponse.swift
//  Starter
//
//  Created by kira on 10/03/2022.
//

import Foundation
import CoreData

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
    let biography: String?
    let birthday: String?
    let homepage: String?
    let id: Int?
    let knownForDepartment: String?
    let name: String?
    let popularity: Double?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case biography
        case birthday
        case homepage
        case id
        case knownForDepartment = "known_for_department"
        case name
        case popularity
        case profilePath = "profile_path"
    }
    
    @discardableResult
    func toActorEntity(context: NSManagedObjectContext) -> ActorEntity {
        let entity = ActorEntity(context: context)
        entity.biography = biography
        entity.birthday = birthday
        entity.homepage = homepage
        entity.id = Int32(id ?? 0)
        entity.knownForDepartment = knownForDepartment
        entity.name = name
        entity.popularity = popularity ?? 0.0
        entity.profilePath = profilePath
        
        return entity
    }
}

