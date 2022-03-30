//
//  CreditsResponse.swift
//  Starter
//
//  Created by kira on 12/03/2022.
//

import Foundation

// MARK: - CreditsResponse
struct CreditsResponse: Codable {
    let id: Int?
    let cast, crew: [Cast]?
}

// MARK: - Cast
struct Cast: Codable {
    let adult: Bool?
    let gender, id: Int?
    let knownForDepartment: String?
    let name, originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castID: Int?
    let character, creditID: String?
    let order: Int?
    let department: String?
    let job: String?
    
    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
    
    func toActorResult() -> ActorResult {
        return ActorResult(
            biography: nil,
            birthday: nil,
            homepage: nil,
            id: id,
            knownForDepartment: knownForDepartment,
            name: name,
            popularity: popularity,
            profilePath: profilePath
        )
    }
    
    func toActorResultObject() -> ActorResultObject {
        let object = ActorResultObject()
        object.id = id!
        object.knownForDepartment = knownForDepartment
        object.name = name
        object.popularity = popularity
        object.profilePath = profilePath
        
        return object
    }
}
