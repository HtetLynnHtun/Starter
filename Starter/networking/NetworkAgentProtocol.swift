//
//  NetworkAgentProtocol.swift
//  Starter
//
//  Created by kira on 17/03/2022.
//

import Foundation

protocol NetworkAgentProtocol {
    func searchMoviesAndSeries(query: String, page: Int, completion: @escaping (MDBResult<SearchResponse>) -> Void)
    func getUpcomingMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getPopularMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getMovieGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void)
    func getTopRatedMovieList(page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getPopularPeople(page: Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void)
    func getPersonDetailsByID(of id: Int, completion: @escaping (MDBResult<ActorDetailResponse>) -> Void)
    func getCombinedCredits(of id: Int, completion: @escaping (MDBResult<ActorCreditsResponse>) -> Void)
    func getMovieDetailsByID(id: Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void)
    func getPopularSeries(completion: @escaping (MDBResult<SeriesListResponse>) -> Void)
    func getMovieCredits(of id: Int, completion: @escaping (MDBResult<CreditsResponse>) -> Void)
    func getSimilarMovies(id: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getMovieTrailers(id: Int, completion: @escaping (MDBResult<TrailersResponse>) -> Void)
    func getSeriesDetailsByID(id: Int, completion: @escaping (MDBResult<SeriesDetailResponse>) -> Void)
    func getSeriesTrailers(id: Int, completion: @escaping (MDBResult<TrailersResponse>) -> Void)
    func getSeriesCredits(of id: Int, completion: @escaping (MDBResult<CreditsResponse>) -> Void)
    func getSimilarSeries(id: Int, completion: @escaping (MDBResult<SeriesListResponse>) -> Void)
}
