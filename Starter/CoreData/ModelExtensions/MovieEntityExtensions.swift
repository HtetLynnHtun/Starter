//
//  MovieEntityExtensions.swift
//  Starter
//
//  Created by kira on 23/03/2022.
//

import Foundation

extension MovieEntity {
    static func toMovieResult(entity: MovieEntity) -> MovieResult {
        var genres = [MovieGenre]()
        if let genresData = entity.genres as? Set<GenreEntity> {
            genres = genresData.map { genreEntity in
                return GenreEntity.toMovieGenre(entity: genreEntity)
            }
        }
        var productionCompanies = [ProductionCompany]()
        if let companyData = entity.productionCompanies as? Set<ProductionCompanyEntity> {
            productionCompanies = companyData.map({ companyEntity in
                return ProductionCompanyEntity.toProductionCompany(entity: companyEntity)
            })
        }
        var productionCountries = [ProductionCountry]()
        if let countryData = entity.productionCountries as? Set<ProductionCountryEntity> {
            productionCountries = countryData.map({ countryEntity in
                return ProductionCountryEntity.toProductionCountry(entity: countryEntity)
            })
        }
        var spokenLanguages = [SpokenLanguage]()
        if let spokenLanguageData = entity.spokenLanguages as? Set<SpokenLanguageEntity> {
            spokenLanguages = spokenLanguageData.map({ spokenLanguageEntity in
                return SpokenLanguageEntity.toSpokenLanguage(entity: spokenLanguageEntity)
            })
        }
        
        return MovieResult(
            adult: entity.adult,
            backdropPath: entity.backdrop,
            belongsToCollection: nil,
            budget: Int(entity.budget),
            episodeRunTime: entity.episodeRunTime?.split(separator: ",").map { Int($0) ?? 0},
            firstAirDate: entity.firstAirDate,
            genres: genres,
            genreIDS: entity.genreIDs?.split(separator: ",").map { Int($0) ?? 0 },
            homepage: entity.homePage ?? "",
            id: Int(entity.id),
            imdbID: entity.imdbID,
            originCountry: nil,
            originalLanguage: nil,
            name: entity.originalName ?? "",
            originalName: entity.originalName ?? "",
            originalTitle: entity.originalTitle,
            overview: entity.overview,
            popularity: entity.popularity,
            productionCompanies: productionCompanies,
            productionCountries: productionCountries,
            posterPath: entity.posterPath,
            releaseDate: entity.releaseDate,
            title: entity.title,
            revenue: Int(entity.revenue),
            runtime: Int(entity.runtime),
            spokenLanguages: spokenLanguages,
            status: entity.status,
            tagline: entity.tagline,
            video: entity.video,
            voteAverage: entity.voteAverage,
            voteCount: Int(entity.voteCount)
        )
    }
}
