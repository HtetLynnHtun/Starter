//
//  MovieViewController.swift
//  Starter
//
//  Created by kira on 08/02/2022.
//

import UIKit
import RxSwift
import RxDataSources
import Differentiator

class MovieViewController: UIViewController, MovieItemDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableViewMovies: UITableView!
    
    // MARK: - propetry
    private let observableUpcomingMovies = RxMovieModel.shared.getUpcomingMovieList()
    private let observablePopularMovies = RxMovieModel.shared.getPopularMovieList()
    private let observablePopularSeries = RxMovieModel.shared.getPopularSeriesList()
    private let observablePopularPeople = PersonModelImpl.shared.getPopularPeople(page: 1)
    private let observableTopRatedMovies = RxMovieModel.shared.getTopRatedMoviesList(page: 1)
    private let observableMovieGenres = RxMovieModel.shared.getMovieGenresList()
    
    // MARK: - view lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        registerTableViewCells()
        
        let dataSource = initDataSource()
        
        Observable.combineLatest(
            observableUpcomingMovies,
            observablePopularMovies,
            observablePopularSeries,
            observablePopularPeople,
            observableTopRatedMovies,
            observableMovieGenres
        ).flatMap { (upcomingMovies, popularMovies, popularSeries, popularPeople, topRatedMovies, movieGernes) -> Observable<[MovieSectionModel]> in
            var allMoviesAndSeries = Set<MediaResult>()
            upcomingMovies.forEach { allMoviesAndSeries.insert($0.toMediaResult())}
            popularMovies.forEach { allMoviesAndSeries.insert($0.toMediaResult())}
            popularSeries.forEach { allMoviesAndSeries.insert($0.toMediaResult())}
            let genreVOs = movieGernes.map { $0.converToVO() }
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
        }.bind(to: tableViewMovies.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func initDataSource() -> RxTableViewSectionedReloadDataSource<MovieSectionModel> {
        RxTableViewSectionedReloadDataSource<MovieSectionModel>.init { dataSource, tableView, indexPath, item in
            switch item {
            case .moviePopularSection(let items):
                let cell = tableView.dequeCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
                cell.delegate = self
                cell.data = items
                return cell
            case .movieSliderSection(let items):
                let cell = tableView.dequeCell(identifier: MovieSliderTableViewCell.identifier, indexPath: indexPath) as MovieSliderTableViewCell
                cell.delegate = self
                cell.data = items
                return cell
            case .seriesPopularSection(let items):
                let cell = tableView.dequeCell(identifier: PopularSeriesTableViewCell.identifier, indexPath: indexPath) as PopularSeriesTableViewCell
                cell.delegate = self
                cell.data = items
                return cell
            case .movieGenreSection(let items, let genres):
                let cell = tableView.dequeCell(identifier: GenreTableViewCell.identifier, indexPath: indexPath) as! GenreTableViewCell
                cell.delegate = self
                cell.allMoviesAndSeries = items
                cell.genreList = genres
                return cell
            case .movieShowTimeSection:
                return tableView.dequeCell(identifier: MovieShowTimeTableViewCell.identifier, indexPath: indexPath)
            case .movieShowCaseSection(let items):
                let cell = tableView.dequeCell(identifier: ShowCaseTableViewCell.identifier, indexPath: indexPath) as! ShowCaseTableViewCell
                cell.data = items
                cell.delegate = self
                cell.onTapMore = self.onTapMore
                return cell
            case .bestActorSection(let items):
                let cell = tableView.dequeCell(identifier: BestActorTableViewCell.identifier, indexPath: indexPath) as! BestActorTableViewCell
                cell.data = items
                cell.onTapActor = self.onTapActor
                cell.onTapMore = self.onTapMore
                return cell
            }
        }
    }
    
    // MARK: - cell registrations
    private func registerTableViewCells () {
        tableViewMovies.registerForCell(MovieSliderTableViewCell.identifier)
        tableViewMovies.registerForCell(PopularFilmTableViewCell.identifier)
        tableViewMovies.registerForCell(PopularSeriesTableViewCell.identifier)
        tableViewMovies.registerForCell(MovieShowTimeTableViewCell.identifier)
        tableViewMovies.registerForCell(GenreTableViewCell.identifier)
        tableViewMovies.registerForCell(ShowCaseTableViewCell.identifier)
        tableViewMovies.registerForCell(BestActorTableViewCell.identifier)
    }
    
    private func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "color_primary")
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                          .foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    let disposeBag = DisposeBag()
    
    private func fetchPopularMovieList() {
        MovieModelImpl.shared.getPopularMovieList()
            .map { [$0] }
            .bind(
                to: tableViewMovies.rx.items(
                    cellIdentifier: PopularFilmTableViewCell.identifier,
                    cellType: PopularFilmTableViewCell.self)
            ) { row, element, cell in
                cell.delegate = self
                cell.data = element
            }.disposed(by: disposeBag)
        
//        MovieModelImpl.shared.getPopularMovieList()
//            .subscribe { data in
//                self.popularMovieList = data
//                self.tableViewMovies.reloadSections(
//                    IndexSet(integer: MovieType.MOVIE_POPULAR.rawValue),
//                    with: .automatic
//                )
//            } onError: { error in
//                print(error)
//            }.disposed(by: disposeBag)
        
//        movieModel.getPopularMovieList { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let popularMovieList):
//                self.popularMovieList = popularMovieList
//                self.tableViewMovies.reloadSections(
//                    IndexSet(integer: MovieType.MOVIE_POPULAR.rawValue),
//                    with: .automatic
//                )
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    // MARK: - onTap callbacks
    @IBAction func onTapSearch(_ sender: UIBarButtonItem) {
        navigateToSearchViewController()
    }
    
    func onTapMovie(id: Int, contentType: DetailContentType) {
        navigateToMovieDetailViewController(id: id, contentType: contentType)
    }
    
    func onTapActor(id: Int) {
        navigateToActorDetailsViewController(id: id)
    }
    
    func onTapMore(contentType: MoreContentType) {
        navigateToMoreContentViewController(contentType: contentType)
    }
}


// Rx Model
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
