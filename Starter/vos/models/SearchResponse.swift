//
//  SearchResponse.swift
//  Starter
//
//  Created by kira on 15/03/2022.
//

import Foundation

struct SearchResponse: Codable {
    let page: Int?
    let results: [SearchResult]
    let totalPages: Int?
    let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct SearchResult: Codable {
    let id: Int?
    let originalTitle: String?
    let originalName: String?
    let mediaType: String?
    let voteAverage: Double?
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "original_title"
        case originalName = "original_name"
        case mediaType = "media_type"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }
    
    func toMediaResult() -> MediaResult {
        return MediaResult(
            id: self.id,
            posterPath: self.posterPath,
            originalTitle: self.mediaType == "tv" ? self.originalName : self.originalTitle,
            voteAverage: self.voteAverage,
            genreIDS: nil,
            contentType: self.mediaType == "tv" ? .series : .movie
        )
    }
}
