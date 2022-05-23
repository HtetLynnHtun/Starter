//
//  PersonModel.swift
//  Starter
//
//  Created by kira on 17/03/2022.
//

import Foundation
import RxSwift

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
    private let actorRepository = ActorRepositoryRealm.shared
    
    private var totalPages = 0
    private let disposeBag = DisposeBag()
    
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
                self.totalPages = self.actorRepository.getTotalPages()
            }
            
            if page > self.totalPages {
                completion(.success([]))
            } else {
                self.actorRepository.getByPage(of: page) { data in
                    completion(.success(data))
                }
            }
        }
    }
    
    // Rx
    func getPopularPeople(page: Int) -> Observable<[ActorResult]> {
        RxNetworkAgent.shared.getPopularPeople(page: page)
            .subscribe(onNext: { data in
                self.actorRepository.saveAll(data: data.results ?? [])
            })
            .disposed(by: disposeBag)
        
        return self.actorRepository.getByPage(of: page)
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