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

}