//
//  MovieGenreList.swift
//  Starter
//
//  Created by kira on 10/03/2022.
//

import Foundation

struct MovieGenreList: Codable {
    let genres: [MovieGenre]
}

struct MovieGenre: Codable {
    let id: Int
    let name: String
    
    func converToVO() -> GenreVO {
        return GenreVO(id: id, name: name, isSelected: false)
    }
}
