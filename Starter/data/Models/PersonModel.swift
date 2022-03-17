//
//  PersonModel.swift
//  Starter
//
//  Created by kira on 17/03/2022.
//

import Foundation

protocol PersonModel {
    func getPopularPeople(page: Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void)
    func getPersonDetailsByID(of id: Int, completion: @escaping (MDBResult<ActorDetailResponse>) -> Void)
    func getCombinedCredits(of id: Int, completion: @escaping (MDBResult<ActorCreditsResponse>) -> Void)
}

class PersonModelImpl: PersonModel {
    static let shared = PersonModelImpl()
    private init() { }
    
    private let networkAgent: NetworkAgentProtocol = AlamofireNetworkAgent.shared
    
    func getPopularPeople(page: Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void) {
        networkAgent.getPopularPeople(page: page, completion: completion)
    }
    
    func getPersonDetailsByID(of id: Int, completion: @escaping (MDBResult<ActorDetailResponse>) -> Void) {
        networkAgent.getPersonDetailsByID(of: id, completion: completion)
    }
    
    func getCombinedCredits(of id: Int, completion: @escaping (MDBResult<ActorCreditsResponse>) -> Void) {
        networkAgent.getCombinedCredits(of: id, completion: completion)
    }
}
