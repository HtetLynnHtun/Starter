//
//  ActorCreditsResponse.swift
//  Starter
//
//  Created by kira on 15/03/2022.
//

import Foundation

struct ActorCreditsResponse: Codable {
    let results: [MovieOrTV]?
    let id: Int?
    
    enum CodingKeys: String, CodingKey {
        case results = "cast"
        case id
    }
}

struct MovieOrTV: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview, releaseDate: String?
    let posterPath: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let title: String?
    let popularity: Double?
    let character, creditID: String?
    let order: Int?
    let mediaType: String?
    let name, originalName: String?
    let originCountry: [String]?
    let firstAirDate: String?
    let episodeCount: Int?

    enum CodingKeys: String, CodingKey {
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case video
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
        case id, adult
        case backdropPath = "backdrop_path"
        case voteCount = "vote_count"
        case genreIDS = "genre_ids"
        case title, popularity, character
        case creditID = "credit_id"
        case order
        case mediaType = "media_type"
        case name
        case originalName = "original_name"
        case originCountry = "origin_country"
        case firstAirDate = "first_air_date"
        case episodeCount = "episode_count"
    }
    
    func toMediaResult() -> MediaResult {
        return MediaResult(
            id: self.id,
            posterPath: self.posterPath,
            originalTitle: self.mediaType == "tv" ? self.originalName : self.originalTitle,
            voteAverage: self.voteAverage,
            genreIDS: self.genreIDS,
            contentType: self.mediaType == "tv" ? .series : .movie
        )
    }
}
