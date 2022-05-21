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
    
    private var viewModel: MovieViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - view lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        registerTableViewCells()
        
        viewModel = MovieViewModel.shared
        viewModel.fetchData()
        viewModel.movieSectionsSubject
            .bind(to: tableViewMovies.rx.items(dataSource: initDataSource()))
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
