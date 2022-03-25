//
//  PersonModel.swift
//  Starter
//
//  Created by kira on 17/03/2022.
//

import Foundation

protocol PersonModel {
    func getPopularPeople(page: Int, completion: @escaping (MDBResult<[ActorResult]>) -> Void)
    func getPersonDetailsByID(of id: Int, completion: @escaping (MDBResult<ActorResult>) -> Void)
    func getCombinedCredits(of id: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getTotalPages() -> Int
}

class PersonModelImpl: PersonModel {
    static let shared = PersonModelImpl()
    private init() { }
    
    private let networkAgent: NetworkAgentProtocol = AlamofireNetworkAgent.shared
    private let actorRepository: ActorRepository = ActorRepositoryImpl.shared
    
    private var totalPages = 0
    
    func getTotalPages() -> Int {
        return totalPages
    }
    
    func getPopularPeople(page: Int, completion: @escaping (MDBResult<[ActorResult]>) -> Void) {
        var networkResult = [ActorResult]()
        
        networkAgent.getPopularPeople(page: page) { result in
            switch result {
            case .success(let data):
                networkResult = data.results ?? []
                self.totalPages = data.totalPages ?? 1
                self.actorRepository.saveAll(data: networkResult)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            if networkResult.isEmpty {
                self.actorRepository.getTotalPages { pages in
                    self.totalPages = pages
                }
            }
            
            self.actorRepository.getByPage(of: page) { data in
                completion(.success(data))
            }
        }
    }
    
    func getPersonDetailsByID(of id: Int, completion: @escaping (MDBResult<ActorResult>) -> Void) {
        networkAgent.getPersonDetailsByID(of: id) { result in
            switch result {
            case .success(let data):
                self.actorRepository.saveDetails(data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            self.actorRepository.getDetails(of: id) { data in
                completion(.success(data))
            }
        }
    }
    
    func getCombinedCredits(of id: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        networkAgent.getCombinedCredits(of: id) { result in
            switch result {
            case .success(let data):
                self.actorRepository.saveCredits(of: id, data: data.results ?? [])
            case .failure(let error):
                print("\(#function) \(error)")
            }
            self.actorRepository.getCredits(of: id) { data in
                completion(.success(data))
            }
        }
    }
}
