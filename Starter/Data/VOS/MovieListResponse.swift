//
//  UpcomingMovieList.swift
//  Starter
//
//  Created by kira on 10/03/2022.
//

import Foundation
import CoreData

// MARK: - MovieListResponse
struct MovieListResponse: Codable {
    let page: Int?
    let results: [MovieResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - MovieResult
struct MovieResult: Codable {
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let genres: [MovieGenre]?
    let genreIDS: [Int]?
    let homepage: String?
    let id: Int?
    let imdbID: String?
    let originCountry: [String]?
    let originalLanguage: String?
    let name: String?
    let originalName: String?
    let originalTitle, overview: String?
    let popularity: Double?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let posterPath, releaseDate, title: String?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline : String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres
        case genreIDS = "genre_ids"
        case homepage
        case id
        case imdbID = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case name
        case originalName = "original_name"
        case originalTitle = "original_title"
        case overview, popularity
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    func toMediaResult() -> MediaResult {
        return MediaResult(
            id: self.id,
            posterPath: self.posterPath,
            originalTitle: self.originalTitle ?? self.originalName,
            voteAverage: self.voteAverage,
            genreIDS: self.genreIDS,
            contentType: self.originalTitle == nil ? .series : .movie
        )
    }
    
    @discardableResult
    func toMovieEntity(context: NSManagedObjectContext, groupType: BelongsToTypeEntity?) -> MovieEntity {
        let entity = MovieEntity(context: context)
        
        entity.adult = adult ?? false
        entity.backdrop = backdropPath
        entity.budget = Int64(budget ?? 0)
        entity.episodeRunTime = episodeRunTime?.map { String($0) }.joined(separator: ", ")
        entity.firstAirDate = firstAirDate
        entity.genreIDs = genreIDS?.map { String($0) }.joined(separator: ", ")
        entity.homePage = homepage
        entity.imdbID = imdbID
        entity.id = Int32(id ?? 0)
        entity.name = name
        entity.originalName = originalName
        entity.originalLanguage = originalLanguage
        entity.originalTitle = originalTitle
        entity.overview = overview
        entity.popularity = popularity ?? 0.0
        entity.posterPath = posterPath
        entity.releaseDate = releaseDate
        entity.title = title
        entity.video = video ?? false
        entity.revenue = Int64(revenue ?? 0)
        entity.runtime = Int64(runtime ?? 0)
        entity.status = status
        entity.tagline = tagline
        entity.voteAverage = voteAverage ?? 0.0
        entity.voteCount = Int64(voteCount ?? 0)
        
        genres?.forEach({ movieGenre in
            let genreEntity = GenreEntity(context: context)
            genreEntity.id = Int32(movieGenre.id)
            genreEntity.name = movieGenre.name
            
            entity.addToGenres(genreEntity)
        })
        
        productionCompanies?.forEach({ company in
            let companyEntity = ProductionCompanyEntity(context: context)
            companyEntity.id = Int32(company.id ?? 0)
            companyEntity.name = company.name
            companyEntity.logoPath = company.logoPath
            companyEntity.originCountry = company.originCountry
            
            entity.addToProductionCompanies(companyEntity)
        })
        
        productionCountries?.forEach({ country in
            let countryEntity = ProductionCountryEntity(context: context)
            countryEntity.name = country.name
            countryEntity.iso3166_1 = country.iso3166_1
            
            entity.addToProductionCountries(countryEntity)
        })
        
        spokenLanguages?.forEach({ spokenLanguage in
            let spokenLanguageEntity = SpokenLanguageEntity(context: context)
            spokenLanguageEntity.name = spokenLanguage.name
            spokenLanguageEntity.englishName = spokenLanguage.englishName
            spokenLanguageEntity.iso3166_1 = spokenLanguage.iso639_1
            
            entity.addToSpokenLanguages(spokenLanguageEntity)
        })
        
        if let groupType = groupType {
            entity.addToBelongsToType(groupType)
        }
        
        return entity
    }
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int?
    let logoPath, name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

struct BelongsToCollection: Codable {
    let id: Int?
    let name, posterPath, backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
