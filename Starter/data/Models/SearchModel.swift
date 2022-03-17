//
//  SearchModel.swift
//  Starter
//
//  Created by kira on 17/03/2022.
//

import Foundation

protocol SearchModel {
    func searchMoviesAndSeries(query: String, page: Int, completion: @escaping (MDBResult<SearchResponse>) -> Void)
}

class SearchModelImpl: SearchModel {
    static let shared = SearchModelImpl()
    private init() { }
    
    private let networkAgent: NetworkAgentProtocol = AlamofireNetworkAgent.shared
    
    func searchMoviesAndSeries(query: String, page: Int, completion: @escaping (MDBResult<SearchResponse>) -> Void) {
        networkAgent.searchMoviesAndSeries(query: query, page: page, completion: completion)
    }
}
