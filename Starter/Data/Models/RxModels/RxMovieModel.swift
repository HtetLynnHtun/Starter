//
//  RxMovieModel.swift
//  Starter
//
//  Created by kira on 06/05/2022.
//

import Foundation
import RxSwift

class RxMovieModel {
    
    static let shared = RxMovieModel()
    private init() { }
    private let movieRepository = RxMovieRepositoryRealm.shared
    private let genreRepository = RxGenreRepositoryRealm.shared
    private let disposeBag = DisposeBag()
    
    func getUpcomingMovieList() -> Observable<[MovieResult]> {
        let contentType: MovieSeriesGroupType = .upcomingMovies
        
        RxNetworkAgent.shared.getUpcomingMovieList()
            .subscribe(onNext: { data in
                self.movieRepository.saveList(data: data.results ?? [], type: contentType)
            })
            .disposed(by: disposeBag)
        
        return RxContentTypeRepositoryRealm.shared.getMoviesOrSeries(type: contentType)
    }
    
    func getPopularMovieList() -> Observable<[MovieResult]> {
        let contentType: MovieSeriesGroupType = .popularMovies
        
        /**
         Show data coming from persistance first
         Make network request
         - success - update persistance -> notify(push) -> Update UI
         - fail - xxx
         */
        
        // When data from remote is arrived, update persistance,
        // all observers to persistance will be notified
        RxNetworkAgent.shared.getPopularMovieList()
            .subscribe(onNext: { data in
                self.movieRepository.saveList(data: data.results ?? [], type: contentType)
            })
            .disposed(by: disposeBag)
        
        // show data from persistance first while requesting data from remote
        return RxContentTypeRepositoryRealm.shared.getMoviesOrSeries(type: contentType)
        
//        return RxNetworkAgent.shared.getPopularMovieList()
//            .do(onNext: { data in
//                self.movieRepository.saveList(data: data.results ?? [], type: contentType)
//            })
//            .catchAndReturn(MovieListResponse.empty())
//            .flatMap { _ -> Observable<[MovieResult]> in
//                return Observable.create { observer in
//                    self.contentTypeRepository.getMoviesOrSeries(type: contentType) { data in
//                        observer.onNext(data)
//                        observer.on(.completed)
//                    }
//                    return Disposables.create()
//                }
//            }
    }

    func getPopularSeriesList() -> Observable<[MovieResult]> {
        let contentType: MovieSeriesGroupType = .popularSeries
        RxNetworkAgent.shared.getPopularSeriesList()
            .subscribe(onNext: { data in
                self.movieRepository.saveList(data: data.results ?? [], type: contentType)
            })
            .disposed(by: disposeBag)
        
        return RxContentTypeRepositoryRealm.shared.getMoviesOrSeries(type: contentType)
    }
    
    func getTopRatedMoviesList(page: Int) -> Observable<[MovieResult]> {
        let contentType: MovieSeriesGroupType = .topRatedMovies
        
        RxNetworkAgent.shared.getTopRatedMoviesList(page: page)
            .subscribe(onNext: { data in
                self.movieRepository.saveList(data: data.results ?? [], type: contentType)
            })
            .disposed(by: disposeBag)
        
        return RxContentTypeRepositoryRealm.shared.getMoviesOrSeries(type: contentType)
    }
    
    func getMovieGenresList() -> Observable<[MovieGenre]> {
        RxNetworkAgent.shared.getMovieGenreList()
            .subscribe(onNext: { data in
                self.genreRepository.save(data: data)
            })
            .disposed(by: disposeBag)
        
        return self.genreRepository.get()
    }
}
