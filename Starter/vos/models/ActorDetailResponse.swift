//
//  ActorDetailResponse.swift
//  Starter
//
//  Created by kira on 14/03/2022.
//

import Foundation

struct ActorDetailResponse: Codable {
    let biography, birthday: String?
    let homepage: String?
    let id: Int?
    let name: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case biography, birthday, homepage, id
        case name
        case profilePath = "profile_path"
    }
}
