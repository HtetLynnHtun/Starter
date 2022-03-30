//
//  MovieResultObject.swift
//  Starter
//
//  Created by kira on 27/03/2022.
//

import Foundation
import RealmSwift

class MovieResultObject: Object {
    
    @Persisted(primaryKey: true)
    var id: Int
    
    @Persisted
    var isUpcoming = false
    
    @Persisted
    var isPopular = false
    
    @Persisted
    var isTopRated = false
    
    @Persisted
    var isSeries = false
    
    @Persisted
    var originalName: String?
    
    @Persisted
    var originalTitle: String?
    
    @Persisted
    var adult: Bool?
    
    @Persisted
    var backdropPath: String?
    
    @Persisted
    var budget: Int?
    
    @Persisted
    var episodeRunTime: List<Int>
    
    @Persisted
    var firstAirDate: String?
    
    @Persisted
    var genreIDS: List<Int>
    
    @Persisted
    var homepage: String?
    
    @Persisted
    var imdbID: String?
    
    @Persisted
    var originCountry: List<String>
    
    @Persisted
    var originalLanguage: String?
    
    @Persisted
    var name: String?
    
    @Persisted
    var overview: String?
    
    @Persisted
    var popularity: Double?
    
    @Persisted
    var posterPath: String?
    
    @Persisted
    var releaseDate: String?
    
    @Persisted
    var title: String?
    
    @Persisted
    var revenue: Int?
    
    @Persisted
    var runtime: Int?
    
    @Persisted
    var status: String?
    
    @Persisted
    var tagline : String?
    
    @Persisted
    var video: Bool?
    
    @Persisted
    var voteAverage: Double?
    
    @Persisted
    var voteCount: Int?
    
    @Persisted
    var genres: List<MovieGenreObject>
    
    @Persisted
    var casts: List<ActorResultObject>
    
    @Persisted
    var similarContents: List<MovieResultObject>
    
    @Persisted
    var belongsToCollection: BelongsToCollectionObject?
    
    @Persisted
    var spokenLanguages: List<SpokenLanguageObject>
    
    @Persisted
    var productionCompanies: List<ProductionCompanyObject>
    
    @Persisted
    var productionCountries: List<ProductionCountryObject>
    
    func toMovieResult() -> MovieResult {
        return MovieResult(
            adult: adult,
            backdropPath: backdropPath,
            belongsToCollection: belongsToCollection?.toBelongsToCollection(),
            budget: budget,
            episodeRunTime: episodeRunTime.map { $0 },
            firstAirDate: firstAirDate,
            genres: genres.map { $0.toMovieGenre() },
            genreIDS: genreIDS.map { $0 },
            homepage: homepage,
            id: id,
            imdbID: imdbID,
            originCountry: originCountry.map { $0 },
            originalLanguage: originalLanguage,
            name: name,
            originalName: originalName,
            originalTitle: originalTitle,
            overview: overview,
            popularity: popularity,
            productionCompanies: productionCompanies.map { $0.toProductionCompany() },
            productionCountries: productionCountries.map { $0.toProductionCountry() },
            posterPath: posterPath,
            releaseDate: releaseDate,
            title: title,
            revenue: revenue,
            runtime: runtime,
            spokenLanguages: spokenLanguages.map { $0.toSpokenLanguage() },
            status: status,
            tagline: tagline,
            video: video,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }
    
}
