//
//  NetworkAgent.swift
//  Starter
//
//  Created by kira on 10/03/2022.
//

import Foundation
import Alamofire

struct MovieDBNetworkAgent {
    static let shared = MovieDBNetworkAgent()
    
    private init() { }
    
    func searchMoviesAndSeries(
        query: String,
        page: Int,
        success: @escaping (SearchResponse) -> Void,
        failure: @escaping (String) -> Void
    ) {
        let urlEncodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = "\(AppConstants.baseURL)/search/multi?query=\(urlEncodedQuery ?? "")&page=\(page)&api_key=\(AppConstants.apiKey)"
        
        AF.request(url)
            .responseDecodable(of: SearchResponse.self) { response in
                switch response.result {
                case .success(let searchResponse):
                    success(searchResponse)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
    }
    
    func getUpcomingMovieList(
        success: @escaping (MovieListResponse) -> Void,
        failure: @escaping (String) -> Void
    ) {
        let url = "\(AppConstants.baseURL)/movie/upcoming?api_key=\(AppConstants.apiKey)"
        
        AF.request(url)
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let upcomingMovieList):
                    success(upcomingMovieList)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
        
    }
    
    func getPopularMovieList(
        success: @escaping (MovieListResponse) -> Void,
        failure: @escaping (String) -> Void
    ) {
        let url = "\(AppConstants.baseURL)/movie/popular?api_key=\(AppConstants.apiKey)"
        
        AF.request(url)
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let popularMovieList):
                    success(popularMovieList)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
        
    }
    
    func getMovieGenreList(
        success: @escaping (MovieGenreList) -> Void,
        failure: @escaping (String) -> Void
    ) {
        let url = "\(AppConstants.baseURL)/genre/movie/list?api_key=\(AppConstants.apiKey)"
        
        AF.request(url)
            .responseDecodable(of: MovieGenreList.self) { response in
                switch response.result {
                case .success(let movieGenreList):
                    success(movieGenreList)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
    }
    
    func getTopRatedMovieList(
        page: Int = 1,
        success: @escaping (MovieListResponse) -> Void,
        failure: @escaping (String) -> Void
    ) {
        let url = "\(AppConstants.baseURL)/movie/top_rated?page=\(page)&api_key=\(AppConstants.apiKey)"
        
        AF.request(url)
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let movieListResponse):
                    success(movieListResponse)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
    }
    
    func getPopularPeople(
        page: Int = 1,
        success: @escaping (ActorListResponse) -> Void,
        failure: @escaping (String) -> Void
    ) {
        let url = "\(AppConstants.baseURL)/person/popular?page=\(page)&api_key=\(AppConstants.apiKey)"
        
        AF.request(url)
            .responseDecodable(of: ActorListResponse.self) { response in
                switch response.result {
                case .success(let actorListResponse):
                    success(actorListResponse)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
    }
    
    func getPersonDetailsByID(
        of id: Int,
        success: @escaping (ActorDetailResponse) -> Void,
        failure: @escaping (String) -> Void
    ) {
        let url = "\(AppConstants.baseURL)/person/\(id)?api_key=\(AppConstants.apiKey)"
        
        AF.request(url)
            .responseDecodable(of: ActorDetailResponse.self) { response in
                switch response.result {
                case .success(let actorDetailResponse):
                    success(actorDetailResponse)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
    }
    
    func getCombinedCredits(
        of id: Int,
        success: @escaping (ActorCreditsResponse) -> Void,
        failure: @escaping (String) -> Void
    ) {
        let url = "\(AppConstants.baseURL)/person/\(id)/combined_credits?api_key=\(AppConstants.apiKey)"
        
        AF.request(url)
            .responseDecodable(of: ActorCreditsResponse.self) { response in
                switch response.result {
                case .success(let data):
                    success(data)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
    }

    func getMovieDetailsByID(
        id: Int,
        success: @escaping (MovieDetailResponse) -> Void,
        failure: @escaping (String) -> Void
    ) {
        let url = "\(AppConstants.baseURL)/movie/\(id)?api_key=\(AppConstants.apiKey)"
        
        AF.request(url)
            .responseDecodable(of: MovieDetailResponse.self) { response in
                switch response.result {
                case .success(let movieDetailResponse):
                    success(movieDetailResponse)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
    }
    
    func getPopularSeries(
        success: @escaping (SeriesListResponse) -> Void,
        failure: @escaping (String) -> Void
    ) {
        let url = "\(AppConstants.baseURL)/tv/popular?api_key=\(AppConstants.apiKey)"
        
        AF.request(url)
            .responseDecodable(of: SeriesListResponse.self) { response in
                switch response.result {
                case .success(let seriesListResponse):
                    success(seriesListResponse)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
    }
    
    func getMovieCredits(
        of id: Int,
        success: @escaping (CreditsResponse) -> Void,
        failure: @escaping (String) -> Void
    ) {
        let url = "\(AppConstants.baseURL)/movie/\(id)/credits?api_key=\(AppConstants.apiKey)"
        
        AF.request(url)
            .responseDecodable(of: CreditsResponse.self) { response in
                switch response.result {
                case .success(let creditsResponse):
                    success(creditsResponse)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
    }
    
    func getSimilarMovies(id: Int, success: @escaping (MovieListResponse) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.baseURL)/movie/\(id)/similar?api_key=\(AppConstants.apiKey)"
        
        AF.request(url)
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let movieListResponse):
                    success(movieListResponse)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
    }
    
    func getMovieTrailers(id: Int, success: @escaping (TrailersResponse) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.baseURL)/movie/\(id)/videos?api_key=\(AppConstants.apiKey)"
        
        AF.request(url)
            .responseDecodable(of: TrailersResponse.self) { response in
                switch response.result {
                case .success(let trailersResponse):
                    success(trailersResponse)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
    }
    
    
    // =========================== Series API =================================
    func getSeriesDetailsByID(
        id: Int,
        success: @escaping (SeriesDetailResponse) -> Void,
        failure: @escaping (String) -> Void
    ) {
        let url = "\(AppConstants.baseURL)/tv/\(id)?api_key=\(AppConstants.apiKey)"
        
        AF.request(url)
            .responseDecodable(of: SeriesDetailResponse.self) { response in
                switch response.result {
                case .success(let seriesDetailResponse):
                    success(seriesDetailResponse)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
    }
    
    func getSeriesTrailers(id: Int, success: @escaping (TrailersResponse) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.baseURL)/tv/\(id)/videos?api_key=\(AppConstants.apiKey)"
        
        AF.request(url)
            .responseDecodable(of: TrailersResponse.self) { response in
                switch response.result {
                case .success(let trailersResponse):
                    success(trailersResponse)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
    }
    
    func getSeriesCredits(
        of id: Int,
        success: @escaping (CreditsResponse) -> Void,
        failure: @escaping (String) -> Void
    ) {
        let url = "\(AppConstants.baseURL)/tv/\(id)/credits?api_key=\(AppConstants.apiKey)"
        
        AF.request(url)
            .responseDecodable(of: CreditsResponse.self) { response in
                switch response.result {
                case .success(let creditsResponse):
                    success(creditsResponse)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
    }
    
    func getSimilarSeries(id: Int, success: @escaping (SeriesListResponse) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.baseURL)/tv/\(id)/similar?api_key=\(AppConstants.apiKey)"
        
        AF.request(url)
            .responseDecodable(of: SeriesListResponse.self) { response in
                switch response.result {
                case .success(let seriesListResponse):
                    success(seriesListResponse)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
    }
}
