//
//  RxPersonModel.swift
//  Starter
//
//  Created by kira on 21/05/2022.
//

import Foundation
import RxSwift

class RxPersonModel {
    static let shared = RxPersonModel()
    
    private let disposeBag = DisposeBag()
    private let actorRepository = RxActorRepositoryRealm.shared
    
    private init() { }
    
    func getPopularPeople(page: Int) -> Observable<[ActorResult]> {
        RxNetworkAgent.shared.getPopularPeople(page: page)
            .subscribe(onNext: { data in
                self.actorRepository.saveAll(data: data.results ?? [])
            })
            .disposed(by: disposeBag)
        
        return self.actorRepository.getByPage(of: page)
    }
}
