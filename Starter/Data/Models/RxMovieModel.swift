//
//  RxMovieModel.swift
//  Starter
//
//  Created by kira on 08/05/2022.
//

import Foundation
import RxSwift

class RxMovieModel {
    
    static let shared = RxMovieModel()
    
    private init() { }
    
    private let disposeBag = DisposeBag()
    
    func getMovieDetailsByID(id: Int) -> Observable<(MovieResult, [ActorResult])> {
        RxNetworkAgent.shared.getMovieDetailsByID(id: id)
            .subscribe(onNext: { data in
                RxMovieRepository.shared.saveDetails(data: data)
            })
            .disposed(by: disposeBag)
        RxNetworkAgent.shared.getMovieCredits(of: id)
            .subscribe(onNext: { data in
                RxMovieRepository.shared.saveMovieCredits(of: id, data: data)
            })
            .disposed(by: disposeBag)
        
        return RxMovieRepository.shared.getMovieDetails(of: id)
    }
    
//    func getMovieCredits(of id: Int) -> Observable<[ActorResult]> {
//        
//    }
    
    func getSimilarMovies(id: Int) -> Observable<[MovieResult]>{
        RxNetworkAgent.shared.getSimilarMovies(id: id)
            .subscribe(onNext: { data in
                RxMovieRepository.shared.saveSimilarMovies(of: id, data: data)
            })
            .disposed(by: disposeBag)
        return RxMovieRepository.shared.getSimilarMovies(of: id)
    }
}
