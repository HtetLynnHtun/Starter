//
//  GenreEntityExtensions.swift
//  Starter
//
//  Created by kira on 23/03/2022.
//

import Foundation

extension GenreEntity {
    static func toMovieGenre(entity: GenreEntity) -> MovieGenre {
        return MovieGenre(
            id: Int(entity.id),
            name: entity.name ?? ""
        )
    }
}
