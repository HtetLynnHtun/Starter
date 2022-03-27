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
    var originalName: String?
    
    @Persisted
    var originalTitle: String?
        
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
    
    //    @Persisted(originProperty: "movies")
    //    var belongsToCollection: LinkingObjects<BelongsToCollectionObject>
    @Persisted
    var belongsToCollection: BelongsToCollectionObject?
    
    @Persisted
    var spokenLanguages: List<SpokenLanguageObject>
    
    @Persisted
    var productionCompanies: List<ProductionCompanyObject>
    
    @Persisted
    var productionCountries: List<ProductionCountryObject>
    
}
