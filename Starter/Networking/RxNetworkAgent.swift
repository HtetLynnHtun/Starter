//
//  RxNetworkAgent.swift
//  Starter
//
//  Created by kira on 04/05/2022.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

class RxNetworkAgent {
    static let shared = RxNetworkAgent()
    
    private init() { }
    
    func getPopularMovieList() -> Observable<MovieListResponse> {
        return RxAlamofire.requestDecodable(URLRequest(url: MDBEndpoint.popularMovies.url))
            .flatMap { (_, data) in
                return Observable.just(data)
            }
//        return Observable.create { observer in
//            AF.request(MDBEndpoint.popularMovies)
//                .responseDecodable(of: MovieListResponse.self) { response in
//                    switch response.result {
//                    case .success(let data):
//                        observer.onNext(data)
//                        observer.onCompleted()
//                    case .failure(let error):
//                        observer.onError(error)
//                    }
//                }
//
//            return Disposables.create()
//        }
    }
    
    func searchMoviesAndSeries(query: String, page: Int) -> Observable<SearchResponse> {
        let urlEncodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return RxAlamofire.requestDecodable(URLRequest(url: MDBEndpoint.search(urlEncodedQuery!, page).url))
            .flatMap { (_, data) in
                return Observable.just(data)
            }
    }
}
