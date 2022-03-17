//
//  SeriesModel.swift
//  Starter
//
//  Created by kira on 17/03/2022.
//

import Foundation

protocol SeriesModel {
    func getPopularSeries(completion: @escaping (MDBResult<SeriesListResponse>) -> Void)
    func getSeriesDetailsByID(id: Int, completion: @escaping (MDBResult<SeriesDetailResponse>) -> Void)
    func getSeriesTrailers(id: Int, completion: @escaping (MDBResult<TrailersResponse>) -> Void)
    func getSeriesCredits(of id: Int, completion: @escaping (MDBResult<CreditsResponse>) -> Void)
    func getSimilarSeries(id: Int, completion: @escaping (MDBResult<SeriesListResponse>) -> Void)
}

class SeriesModelImpl: SeriesModel {
    static let shared = SeriesModelImpl()
    private init() { }
    
    private let networkAgent: NetworkAgentProtocol = AlamofireNetworkAgent.shared
    
    func getPopularSeries(completion: @escaping (MDBResult<SeriesListResponse>) -> Void) {
        networkAgent.getPopularSeries(completion: completion)
    }
    
    func getSeriesDetailsByID(id: Int, completion: @escaping (MDBResult<SeriesDetailResponse>) -> Void) {
        networkAgent.getSeriesDetailsByID(id: id, completion: completion)
    }
    
    func getSeriesTrailers(id: Int, completion: @escaping (MDBResult<TrailersResponse>) -> Void) {
        networkAgent.getSeriesTrailers(id: id, completion: completion)
    }
    
    func getSeriesCredits(of id: Int, completion: @escaping (MDBResult<CreditsResponse>) -> Void) {
        networkAgent.getSeriesCredits(of: id, completion: completion)
    }
    
    func getSimilarSeries(id: Int, completion: @escaping (MDBResult<SeriesListResponse>) -> Void) {
        networkAgent.getSimilarSeries(id: id, completion: completion)
    }
    
}
