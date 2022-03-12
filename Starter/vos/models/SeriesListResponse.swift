//
//  SeriesListResponse.swift
//  Starter
//
//  Created by kira on 11/03/2022.
//

import Foundation

// MARK: - SeriesListResponse
struct SeriesListResponse: Codable {
    let page: Int?
    let results: [SeriesResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct SeriesResult: Codable {
    let backdropPath, firstAirDate: String?
    let genreIDS: [Int]?
    let id: Int?
    let name: String?
    let originCountry: [String]?
    let originalLanguage: String?
    let originalName, overview: String?
    let popularity: Double?
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIDS = "genre_ids"
        case id, name
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    func toMediaResult() -> MediaResult {
        return MediaResult(id: self.id, posterPath: self.posterPath, originalTitle: self.originalName, voteAverage: self.voteAverage, genreIDS: self.genreIDS)
        
    }
}
