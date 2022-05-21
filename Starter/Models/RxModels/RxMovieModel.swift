//
//  RxMovieModel.swift
//  Starter
//
//  Created by kira on 06/05/2022.
//

import Foundation
import RxSwift

protocol RxMovieModel {
    func getUpcomingMovieList() -> Observable<[MovieResult]>
    func getPopularMovieList() -> Observable<[MovieResult]>
    func getPopularSeriesList() -> Observable<[MovieResult]>
    func getTopRatedMoviesList(page: Int) -> Observable<[MovieResult]>
    func getMovieGenresList() -> Observable<[MovieGenre]>
    func getMovieDetailsByID(id: Int) -> Observable<MovieResult>
    func getMovieCredits(id: Int) -> Observable<[ActorResult]>
    func getSimilarMovies(id: Int) -> Observable<[MovieResult]>
    func getMovieTrailers(id: Int) -> Observable<TrailersResponse>
}

class RxMovieModelImpl: RxMovieModel {
    
    static let shared = RxMovieModelImpl()
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
        
        RxNetworkAgent.shared.getPopularMovieList()
            .subscribe(onNext: { data in
                self.movieRepository.saveList(data: data.results ?? [], type: contentType)
            })
            .disposed(by: disposeBag)
        
        return RxContentTypeRepositoryRealm.shared.getMoviesOrSeries(type: contentType)
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
    
    func getMovieDetailsByID(id: Int) -> Observable<MovieResult> {
        RxNetworkAgent.shared.getMovieDetailsByID(id: id)
            .subscribe(onNext: { data in
                self.movieRepository.saveDetails(data: data)
            })
            .disposed(by: disposeBag)
        
        return self.movieRepository.getDetails(of: id)
    }
    
    func getMovieCredits(id: Int) -> Observable<[ActorResult]> {
        RxNetworkAgent.shared.getMovieCredits(id: id)
            .subscribe(onNext: { data in
                self.movieRepository.saveMovieCredits(of: id, data: data)
            })
            .disposed(by: disposeBag)
        
        return self.movieRepository.getMovieCredits(of: id)
    }
    
    func getSimilarMovies(id: Int) -> Observable<[MovieResult]> {
        RxNetworkAgent.shared.getSimilarMovies(id: id)
            .subscribe(onNext: { data in
                self.movieRepository.saveSimilarMovies(of: id, data: data)
            })
            .disposed(by: disposeBag)
        
        return self.movieRepository.getSimilarMovies(of: id)
    }
    
    func getMovieTrailers(id: Int) -> Observable<TrailersResponse> {
        return RxNetworkAgent.shared.getMovieTrailers(id: id)
    }
}
