//
//  MovieModel.swift
//  Starter
//
//  Created by kira on 17/03/2022.
//

import Foundation

protocol MovieModel {
    func getUpcomingMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getPopularMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getMovieGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void)
    func getTopRatedMovieList(page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getMovieDetailsByID(id: Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void)
    func getMovieCredits(of id: Int, completion: @escaping (MDBResult<CreditsResponse>) -> Void)
    func getSimilarMovies(id: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getMovieTrailers(id: Int, completion: @escaping (MDBResult<TrailersResponse>) -> Void)
}

class MovieModelImpl: MovieModel {
    static let shared = MovieModelImpl()
    private init() { }
    
    let networkAgent: NetworkAgentProtocol = AlamofireNetworkAgent.shared
    
    func getUpcomingMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        networkAgent.getUpcomingMovieList(completion: completion)
    }
    
    func getPopularMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        networkAgent.getPopularMovieList(completion: completion)
    }
    
    func getMovieGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void) {
        networkAgent.getMovieGenreList(completion: completion)
    }
    
    func getTopRatedMovieList(page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        networkAgent.getTopRatedMovieList(page: page, completion: completion)
    }
    
    func getMovieDetailsByID(id: Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        networkAgent.getMovieDetailsByID(id: id, completion: completion)
    }
    
    func getMovieCredits(of id: Int, completion: @escaping (MDBResult<CreditsResponse>) -> Void) {
        networkAgent.getMovieCredits(of: id, completion: completion)
    }
    
    func getSimilarMovies(id: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        networkAgent.getSimilarMovies(id: id, completion: completion)
    }
    
    func getMovieTrailers(id: Int, completion: @escaping (MDBResult<TrailersResponse>) -> Void) {
        networkAgent.getMovieTrailers(id: id, completion: completion)
    }
}
