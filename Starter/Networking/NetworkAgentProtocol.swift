//
//  NetworkAgentProtocol.swift
//  Starter
//
//  Created by kira on 17/03/2022.
//

import Foundation

protocol NetworkAgentProtocol {
    // searching
    func searchMoviesAndSeries(query: String, page: Int, completion: @escaping (MDBResult<SearchResponse>) -> Void)
    
    // movie
    func getUpcomingMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getPopularMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getMovieGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void)
    func getTopRatedMovieList(page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getMovieDetailsByID(id: Int, completion: @escaping (MDBResult<MovieResult>) -> Void)
    func getMovieCredits(of id: Int, completion: @escaping (MDBResult<CreditsResponse>) -> Void)
    func getSimilarMovies(id: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getMovieTrailers(id: Int, completion: @escaping (MDBResult<TrailersResponse>) -> Void)
    
    // series
    func getPopularSeries(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getSeriesDetailsByID(id: Int, completion: @escaping (MDBResult<MovieResult>) -> Void)
    func getSeriesTrailers(id: Int, completion: @escaping (MDBResult<TrailersResponse>) -> Void)
    func getSeriesCredits(of id: Int, completion: @escaping (MDBResult<CreditsResponse>) -> Void)
    func getSimilarSeries(id: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    
    // person
    func getPopularPeople(page: Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void)
    func getPersonDetailsByID(of id: Int, completion: @escaping (MDBResult<ActorResult>) -> Void)
    func getCombinedCredits(of id: Int, completion: @escaping (MDBResult<ActorCreditsResponse>) -> Void)
}
