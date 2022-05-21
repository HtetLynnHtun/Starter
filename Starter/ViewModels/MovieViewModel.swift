//
//  MovieViewModel.swift
//  Starter
//
//  Created by kira on 21/05/2022.
//

import Foundation
import RxSwift
import Differentiator

protocol MovieViewModel {
    var movieSectionsSubject: BehaviorSubject<[MovieSectionModel]> { get }
    
    func fetchData()
}

class MovieViewModelImpl: MovieViewModel {
    static let shared = MovieViewModelImpl()
    
    // MARK: - States
    let movieSectionsSubject = BehaviorSubject(value: [MovieSectionModel]())
    
    // TODO: swap with protocol
    private let movieModel: RxMovieModel = RxMovieModelImpl.shared
    private let personModel = RxPersonModel.shared
    
    private let upcomingMoviesSubject = BehaviorSubject(value: [MovieResult]())
    private let popularMoviesSubject = BehaviorSubject(value: [MovieResult]())
    private let popularSeriesSubject = BehaviorSubject(value: [MovieResult]())
    private let topRatedMoviesSubject = BehaviorSubject(value: [MovieResult]())
    private let movieGenresSubject = BehaviorSubject(value: [MovieGenre]())
    private let popularPeopleSubject = BehaviorSubject(value: [ActorResult]())
    private let disposeBag = DisposeBag()
    
    private init() {
        listenToAll()
    }
    
    private func listenToAll() {
        Observable.combineLatest(
            upcomingMoviesSubject,
            popularMoviesSubject,
            popularSeriesSubject,
            topRatedMoviesSubject,
            movieGenresSubject,
            popularPeopleSubject
        )
        .flatMap { (upcomingMovies,
                    popularMovies,
                    popularSeries,
                    topRatedMovies,
                    movieGenres,
                    popularPeople) -> Observable<[MovieSectionModel]> in
            
            var allMoviesAndSeries = Set<MediaResult>()
            upcomingMovies.forEach { allMoviesAndSeries.insert($0.toMediaResult())}
            popularMovies.forEach { allMoviesAndSeries.insert($0.toMediaResult())}
            popularSeries.forEach { allMoviesAndSeries.insert($0.toMediaResult())}
            let genreVOs = movieGenres.map { $0.converToVO() }
            genreVOs.first?.isSelected = true
            
            return Observable.just([
                .movieResult(items: [.movieSliderSection(items: upcomingMovies)]),
                .movieResult(items: [.moviePopularSection(items: popularMovies)]),
                .movieResult(items: [.seriesPopularSection(items: popularSeries)]),
                .movieResult(items: [.movieShowTimeSection]),
                .movieResult(items: [.movieGenreSection(items: allMoviesAndSeries, genres: genreVOs)]),
                .movieResult(items: [.movieShowCaseSection(items: topRatedMovies)]),
                .actorResult(items: [.bestActorSection(items: popularPeople)])
            ])
        }
        .subscribe(onNext: { self.movieSectionsSubject.onNext($0) })
        .disposed(by: disposeBag)
    }
    
    func fetchData() {
        movieModel.getUpcomingMovieList()
            .subscribe(onNext: { self.upcomingMoviesSubject.onNext($0)})
            .disposed(by: disposeBag)
        
        movieModel.getPopularMovieList()
            .subscribe(onNext: { self.popularMoviesSubject.onNext($0)})
            .disposed(by: disposeBag)
        
        movieModel.getPopularSeriesList()
            .subscribe(onNext: { self.popularSeriesSubject.onNext($0)})
            .disposed(by: disposeBag)
        
        movieModel.getTopRatedMoviesList(page: 1)
            .subscribe(onNext: { self.topRatedMoviesSubject.onNext($0)})
            .disposed(by: disposeBag)
        
        movieModel.getMovieGenresList()
            .subscribe(onNext: { self.movieGenresSubject.onNext($0)})
            .disposed(by: disposeBag)
        
        personModel.getPopularPeople(page: 1)
            .subscribe(onNext: { self.popularPeopleSubject.onNext($0)})
            .disposed(by: disposeBag)

    }
    
}


enum SectionItem {
    case movieSliderSection(items: [MovieResult])
    case moviePopularSection(items: [MovieResult])
    case seriesPopularSection(items: [MovieResult])
    case movieShowTimeSection
    case movieGenreSection(items: Set<MediaResult>, genres: [GenreVO])
    case movieShowCaseSection(items: [MovieResult])
    case bestActorSection(items: [ActorResult])
}

enum MovieSectionModel: SectionModelType {
    
    case movieResult(items: [SectionItem])
    case actorResult(items: [SectionItem])
    
    typealias Item = SectionItem
    
    init(original: MovieSectionModel, items: [SectionItem]) {
        switch original {
        case .movieResult(let results):
            self = .movieResult(items: results)
        case .actorResult(let results):
            self = .actorResult(items: results)
        }
    }
    
    var items: [SectionItem] {
        switch self {
        case .movieResult(let items):
            return items
        case .actorResult(let items):
            return items
        }
    }
    
}

