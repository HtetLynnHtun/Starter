//
//  MovieViewController.swift
//  Starter
//
//  Created by kira on 08/02/2022.
//

import UIKit

class MovieViewController: UIViewController, MovieItemDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableViewMovies: UITableView!
    
    // MARK: - propetry
    private let movieModel: MovieModel = MovieModelImpl.shared
    private let personModel: PersonModel = PersonModelImpl.shared
    private let seriesModel: SeriesModel = SeriesModelImpl.shared
    private var upcomingMovieList: [MovieResult]?
    private var popularMovieList: [MovieResult]?
    private var popularSeriesList: [MovieResult]?
    private var topRatedMovieList: [MovieResult]?
    private var movieGenreList: [MovieGenre]?
    private var popularPeople: [ActorResult]?
    
    // MARK: - view lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        registerTableViewCells()
        fetchUpcomingMovieList()
        fetchPopularMovieList()
        fetchPopularSeries()
        fetchMovieGenreList()
        fetchTopRatedMovieList()
        fetchPopularPeople()
    }
    
    // MARK: - cell registrations
    private func registerTableViewCells () {
        tableViewMovies.dataSource = self
        
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
    
    // MARK: - api methods
    private func fetchUpcomingMovieList() {
        movieModel.getUpcomingMovieList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let upcomingMovieList):
                self.upcomingMovieList = upcomingMovieList
                self.tableViewMovies.reloadSections(
                    IndexSet(integer: MovieType.MOVIE_SLIDER.rawValue),
                    with: .automatic
                )
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchPopularMovieList() {
        movieModel.getPopularMovieList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let popularMovieList):
                self.popularMovieList = popularMovieList
                self.tableViewMovies.reloadSections(
                    IndexSet(integer: MovieType.MOVIE_POPULAR.rawValue),
                    with: .automatic
                )
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchTopRatedMovieList() {
        movieModel.getTopRatedMovieList(page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let topRatedMovieList):
                self.topRatedMovieList = topRatedMovieList.sorted(by: { first, second -> Bool in
                    return first.voteAverage! > second.voteAverage!
                })
                self.tableViewMovies.reloadSections(
                    IndexSet(integer: MovieType.MOIVE_SHOWCASE.rawValue),
                    with: .automatic
                )
            case .failure(let error):
                print(error)
            }
        }

    }
    
    private func fetchMovieGenreList() {
        movieModel.getMovieGenreList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movieGenreList):
                self.movieGenreList = movieGenreList
                self.tableViewMovies.reloadSections(
                    IndexSet(integer: MovieType.MOVIE_GENRE.rawValue),
                    with: .automatic
                )
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchPopularPeople() {
        personModel.getPopularPeople(page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let actorListResponse):
                self.popularPeople = actorListResponse
                self.tableViewMovies.reloadSections(
                    IndexSet(integer: MovieType.MOVIE_BESTACTOR.rawValue),
                    with: .automatic
                )
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchPopularSeries() {
        seriesModel.getPopularSeries { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let seriesListResponse):
                self.popularSeriesList = seriesListResponse
                self.tableViewMovies.reloadSections(
                    IndexSet(integer: MovieType.SERIES_POPULAR.rawValue),
                    with: .automatic
                )
            case .failure(let error):
                print(error)
            }
        }
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

// MARK: - ViewController extensions
extension MovieViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case MovieType.MOVIE_SLIDER.rawValue:
            let cell = tableView.dequeCell(identifier: MovieSliderTableViewCell.identifier, indexPath: indexPath) as MovieSliderTableViewCell
            cell.delegate = self
            cell.data = self.upcomingMovieList
            return cell
            
            case MovieType.MOVIE_POPULAR.rawValue:
            let cell = tableView.dequeCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
            cell.delegate = self
            cell.data = self.popularMovieList
            return cell
            
            case MovieType.SERIES_POPULAR.rawValue:
            let cell = tableView.dequeCell(identifier: PopularSeriesTableViewCell.identifier, indexPath: indexPath) as PopularSeriesTableViewCell
            cell.delegate = self
            cell.data = self.popularSeriesList
            return cell
            
            case MovieType.MOVIE_SHOWTIME.rawValue:
                return tableView.dequeCell(identifier: MovieShowTimeTableViewCell.identifier, indexPath: indexPath)
            
            case MovieType.MOVIE_GENRE.rawValue:
            let cell = tableView.dequeCell(identifier: GenreTableViewCell.identifier, indexPath: indexPath) as! GenreTableViewCell
            cell.delegate = self
            var allMoviesAndSeries = Set<MediaResult>()
            self.upcomingMovieList?.forEach({ movieResult in
                allMoviesAndSeries.insert(movieResult.toMediaResult())
            })
            self.popularMovieList?.forEach({ movieResult in
                allMoviesAndSeries.insert(movieResult.toMediaResult())
            })
            self.popularSeriesList?.forEach({ seriesResult in
                allMoviesAndSeries.insert(seriesResult.toMediaResult())
            })
            cell.allMoviesAndSeries = allMoviesAndSeries
            
            let genreVOList = self.movieGenreList?.map({ genre in
                return genre.converToVO()
            })
            genreVOList?.first?.isSelected = true
            cell.genreList = genreVOList
            return cell
            
            case MovieType.MOIVE_SHOWCASE.rawValue:
                let cell = tableView.dequeCell(identifier: ShowCaseTableViewCell.identifier, indexPath: indexPath) as! ShowCaseTableViewCell
            cell.data = topRatedMovieList
            cell.delegate = self
            cell.onTapMore = onTapMore
            return cell
            
            case MovieType.MOVIE_BESTACTOR.rawValue:
                let cell = tableView.dequeCell(identifier: BestActorTableViewCell.identifier, indexPath: indexPath) as! BestActorTableViewCell
            cell.data = popularPeople
            cell.onTapActor = onTapActor
            cell.onTapMore = onTapMore
            return cell
            default:
                return UITableViewCell()
            }
        }
}
