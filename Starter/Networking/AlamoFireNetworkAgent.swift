//
//  NetworkAgent.swift
//  Starter
//
//  Created by kira on 10/03/2022.
//

import Foundation
import Alamofire

struct AlamofireNetworkAgent: NetworkAgentProtocol {
    static let shared = AlamofireNetworkAgent()
    
    private init() { }
    
    func searchMoviesAndSeries(
        query: String,
        page: Int,
        completion: @escaping (MDBResult<SearchResponse>) -> Void
    ) {
        let urlEncodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(MDBEndpoint.search(urlEncodedQuery!, page))
            .responseDecodable(of: SearchResponse.self) { response in
                switch response.result {
                case .success(let searchResponse):
                    completion(.success(searchResponse))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommomResponseError.self)))
                }
            }
    }
    
    func getUpcomingMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        AF.request(MDBEndpoint.upcomingMovies)
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let upcomingMovieList):
                    completion(.success(upcomingMovieList))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommomResponseError.self)))
                }
            }
    }
    
    func getPopularMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        AF.request(MDBEndpoint.popularMovies)
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let popularMovieList):
                    completion(.success(popularMovieList))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommomResponseError.self)))
                }
            }
    }
    
    func getMovieGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void) {
        AF.request(MDBEndpoint.movieGenres)
            .responseDecodable(of: MovieGenreList.self) { response in
                switch response.result {
                case .success(let movieGenreList):
                    completion(.success(movieGenreList))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommomResponseError.self)))
                }
            }
    }
    
    func getTopRatedMovieList(
        page: Int = 1,
        completion: @escaping (MDBResult<MovieListResponse>) -> Void
    ) {
        AF.request(MDBEndpoint.topRatedMovies(page))
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let movieListResponse):
                    completion(.success(movieListResponse))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommomResponseError.self)))
                }
            }
    }
    
    func getPopularPeople(
        page: Int = 1,
        completion: @escaping (MDBResult<ActorListResponse>) -> Void
    ) {
        AF.request(MDBEndpoint.popularPeople(page))
            .responseDecodable(of: ActorListResponse.self) { response in
                switch response.result {
                case .success(let actorListResponse):
                    completion(.success(actorListResponse))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommomResponseError.self)))
                }
            }
    }
    
    func getPersonDetailsByID(
        of id: Int,
        completion: @escaping (MDBResult<ActorResult>) -> Void
    ) {
        AF.request(MDBEndpoint.personDetails(id))
            .responseDecodable(of: ActorResult.self) { response in
                switch response.result {
                case .success(let actorResult):
                    completion(.success(actorResult))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommomResponseError.self)))
                }
            }
    }
    
    func getCombinedCredits(
        of id: Int,
        completion: @escaping (MDBResult<ActorCreditsResponse>) -> Void
    ) {
        AF.request(MDBEndpoint.combinedCredits(id))
            .responseDecodable(of: ActorCreditsResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommomResponseError.self)))
                }
            }
    }

    func getMovieDetailsByID(
        id: Int,
        completion: @escaping (MDBResult<MovieResult>) -> Void
    ) {
        AF.request(MDBEndpoint.movieDetails(id))
            .responseDecodable(of: MovieResult.self) { response in
                switch response.result {
                case .success(let movieReuslt):
                    completion(.success(movieReuslt))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommomResponseError.self)))
                }
            }
    }
    
    func getPopularSeries(completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        AF.request(MDBEndpoint.popularSeries)
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let moviesListResponse):
                    completion(.success(moviesListResponse))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommomResponseError.self)))
                }
            }
    }
    
    func getMovieCredits(
        of id: Int,
        completion: @escaping (MDBResult<CreditsResponse>) -> Void
    ) {
        AF.request(MDBEndpoint.movieCredits(id))
            .responseDecodable(of: CreditsResponse.self) { response in
                switch response.result {
                case .success(let creditsResponse):
                    completion(.success(creditsResponse))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommomResponseError.self)))
                }
            }
    }
    
    func getSimilarMovies(id: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        AF.request(MDBEndpoint.similarMovies(id))
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let movieListResponse):
                    completion(.success(movieListResponse))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommomResponseError.self)))
                }
            }
    }
    
    func getMovieTrailers(id: Int, completion: @escaping (MDBResult<TrailersResponse>) -> Void) {
        AF.request(MDBEndpoint.movieTrailers(id))
            .responseDecodable(of: TrailersResponse.self) { response in
                switch response.result {
                case .success(let trailersResponse):
                    completion(.success(trailersResponse))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommomResponseError.self)))
                }
            }
    }
    
    
    // =========================== Series API =================================
    func getSeriesDetailsByID(
        id: Int,
        completion: @escaping (MDBResult<MovieResult>) -> Void
    ) {
        AF.request(MDBEndpoint.seriesDetails(id))
            .responseDecodable(of: MovieResult.self) { response in
                switch response.result {
                case .success(let seriesDetailResponse):
                    completion(.success(seriesDetailResponse))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommomResponseError.self)))
                }
            }
    }
    
    func getSeriesTrailers(id: Int, completion: @escaping (MDBResult<TrailersResponse>) -> Void) {
        AF.request(MDBEndpoint.seriesTrailers(id))
            .responseDecodable(of: TrailersResponse.self) { response in
                switch response.result {
                case .success(let trailersResponse):
                    completion(.success(trailersResponse))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommomResponseError.self)))
                }
            }
    }
    
    func getSeriesCredits(
        of id: Int,
        completion: @escaping (MDBResult<CreditsResponse>) -> Void
    ) {
        AF.request(MDBEndpoint.seriesCredits(id))
            .responseDecodable(of: CreditsResponse.self) { response in
                switch response.result {
                case .success(let creditsResponse):
                    completion(.success(creditsResponse))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommomResponseError.self)))
                }
            }
    }
    
    func getSimilarSeries(id: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        AF.request(MDBEndpoint.similarSeries(id))
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let seriesListResponse):
                    completion(.success(seriesListResponse))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommomResponseError.self)))
                }
            }
    }
    
    /**
     ===== These could have happened! =====
     
     * JSON Serialization Error - key mismatch, expected key not found,
     * Wrong API Endpoint
     * Wrong http method - use "GET" instead of "POST"
     * Invalid credentials - no credentials, expired credentials
     * 4xx - client error, 401 - valid credentails?, 404 - wrong endpoint?,
     * 5xx - server error
     
     */
    
    private func handleError<T, E: MDBErrorModel> (
        _ response: DataResponse<T, AFError>,
        _ error: AFError,
        _ errorBodyType: E.Type
    ) -> String {
        var respBody = ""
        var serverErrorMessage: String?
        var errorBody: E?
        
        if let respData = response.data {
            respBody = String(data: respData, encoding: .utf8) ?? "empty response body"
            
            errorBody = try? JSONDecoder().decode(errorBodyType, from: respData)
            serverErrorMessage = errorBody?.message
        }
        
        let respCode = response.response?.statusCode ?? 0
        let sourcePath = response.request?.url?.absoluteString ?? "no URL"
        
        print(
            """
            =================
            URL
            -> \(sourcePath)
            
            status
            -> \(respCode)
            
            Body
            -> \(respBody)
            
            Underlying Error
            -> \(error.underlyingError!)
            
            Error Description
            -> \(error.errorDescription!)
            """
        )
        
        return serverErrorMessage ?? error.errorDescription ?? "undefined"
    }
    
}

protocol MDBErrorModel: Decodable {
    var message: String { get }
}

class MDBCommomResponseError: MDBErrorModel {
    var message: String {
        return statusMessage
    }
    
    let statusMessage: String
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}

enum MDBResult<T> {
    case success(T)
    case failure(String)
}
