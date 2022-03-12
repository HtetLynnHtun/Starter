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
        success: @escaping (MovieListResponse) -> Void,
        failure: @escaping (String) -> Void
    ) {
        let url = "\(AppConstants.baseURL)/movie/top_rated?api_key=\(AppConstants.apiKey)"
        
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
        success: @escaping (ActorListResponse) -> Void,
        failure: @escaping (String) -> Void
    ) {
        let url = "\(AppConstants.baseURL)/person/popular?api_key=\(AppConstants.apiKey)"
        
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
}
