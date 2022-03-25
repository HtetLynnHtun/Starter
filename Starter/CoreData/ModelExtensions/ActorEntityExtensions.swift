//
//  ActorEntityExtensions.swift
//  Starter
//
//  Created by kira on 24/03/2022.
//

import Foundation

extension ActorEntity {
    static func toActorResult(entity: ActorEntity) -> ActorResult {
        return ActorResult(
            biography: entity.biography,
            birthday: entity.birthday,
            homepage: entity.homepage,
            id: Int(entity.id),
            knownForDepartment: entity.knownForDepartment,
            name: entity.name,
            popularity: entity.popularity,
            profilePath: entity.profilePath
        )
    }
}
