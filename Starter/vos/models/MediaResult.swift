//
//  MediaResult.swift
//  Starter
//
//  Created by kira on 11/03/2022.
//

import Foundation

struct MediaResult: Hashable {
    let id: Int?
    let posterPath: String?
    let originalTitle: String?
    let voteAverage: Double?
    let genreIDS: [Int]?
}
