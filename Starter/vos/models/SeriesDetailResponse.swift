//
//  SeriesDetailResponse.swift
//  Starter
//
//  Created by kira on 13/03/2022.
//

import Foundation

// MARK: - SeriesDetailResponse
struct SeriesDetailResponse: Codable {
    let backdropPath: String?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let genres: [MovieGenre]?
    let id: Int?
    let name: String?
    let originCountry: [String]?
    let originalName, overview: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres, id
        case name
        case originCountry = "origin_country"
        case originalName = "original_name"
        case overview
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
