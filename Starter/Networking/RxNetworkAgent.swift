//
//  RxNetworkAgent.swift
//  Starter
//
//  Created by kira on 08/05/2022.
//

import Foundation
import RxSwift
import RxAlamofire

class RxNetworkAgent {
    static let shared = RxNetworkAgent()
    private init() { }
    
    func getMovieDetailsByID(id: Int) -> Observable<MovieResult> {
        return RxAlamofire.requestDecodable(URLRequest(url: MDBEndpoint.movieDetails(id).url))
            .flatMap { (_, data) in
                return Observable.just(data)
            }
    }
    
    func getSimilarMovies(id: Int) -> Observable<MovieListResponse> {
        return RxAlamofire.requestDecodable(URLRequest(url: MDBEndpoint.similarMovies(id).url))
            .flatMap { (_, data) in
                return Observable.just(data)
            }
    }
    
    func getMovieCredits(of id: Int) -> Observable<CreditsResponse> {
        return RxAlamofire.requestDecodable(URLRequest(url: MDBEndpoint.movieCredits(id).url))
            .flatMap { (_, data) in
                return Observable.just(data)
            }
    }
    
}
