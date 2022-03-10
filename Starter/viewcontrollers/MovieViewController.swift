//
//  MovieViewController.swift
//  Starter
//
//  Created by kira on 08/02/2022.
//

import UIKit

class MovieViewController: UIViewController, MovieItemDelegate {
    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet weak var ivMenu: UIImageView!
    @IBOutlet weak var tableViewMovies: UITableView!
    @IBOutlet weak var viewForToolbar: UIView!
    
    private let networkAgent = MovieDBNetworkAgent.shared
    private var upcomingMovieList: MovieListResponse?
    private var popularMovieList: MovieListResponse?
    private var topRatedMovieList: MovieListResponse?
    private var movieGenreList: MovieGenreList?
    private var popularPeople: ActorListResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
        fetchUpcomingMovieList()
        fetchPopularMovieList()
        fetchMovieGenreList()
        fetchTopRatedMovieList()
        fetchPopularPeople()
    }
    
    func onTapMovie() {
        navigateToMovieDetailViewController()
    }
    
    private func registerTableViewCells () {
        tableViewMovies.dataSource = self
        
        tableViewMovies.registerForCell(MovieSliderTableViewCell.identifier)
        tableViewMovies.registerForCell(PopularFilmTableViewCell.identifier)
        tableViewMovies.registerForCell(MovieShowTimeTableViewCell.identifier)
        tableViewMovies.registerForCell(GenreTableViewCell.identifier)
        tableViewMovies.registerForCell(ShowCaseTableViewCell.identifier)
        tableViewMovies.registerForCell(BestActorTableViewCell.identifier)
    }
    
    private func fetchUpcomingMovieList() {
        networkAgent.getUpcomingMovieList { upcomingMovieList in
            self.upcomingMovieList = upcomingMovieList
            self.tableViewMovies.reloadSections(
                IndexSet(integer: MovieType.MOVIE_SLIDER.rawValue),
                with: .automatic
            )
        } failure: { error in
            print(error)
        }
    }
    
    private func fetchPopularMovieList() {
        networkAgent.getPopularMovieList { popularMovieList in
            self.popularMovieList = popularMovieList
            self.tableViewMovies.reloadSections(
                IndexSet(integer: MovieType.MOVIE_POPULAR.rawValue),
                with: .automatic
            )
        } failure: { error in
            print(error)
        }

    }
    
    private func fetchTopRatedMovieList() {
        networkAgent.getTopRatedMovieList { topRatedMovieList in
            self.topRatedMovieList = topRatedMovieList
            self.tableViewMovies.reloadSections(
                IndexSet(integer: MovieType.MOIVE_SHOWCASE.rawValue),
                with: .automatic
            )
        } failure: { error in
            print(error)
        }

    }
    
    private func fetchMovieGenreList() {
        networkAgent.getMovieGenreList { movieGenreList in
            self.movieGenreList = movieGenreList
            self.tableViewMovies.reloadSections(
                IndexSet(integer: MovieType.MOVIE_GENRE.rawValue),
                with: .automatic
            )
        } failure: { error in
            print(error)
        }

    }
    
    private func fetchPopularPeople() {
        networkAgent.getPopularPeople { actorListResponse in
            self.popularPeople = actorListResponse
            self.tableViewMovies.reloadSections(
                IndexSet(integer: MovieType.MOVIE_BESTACTOR.rawValue),
                with: .automatic
            )
        } failure: { error in
            print(error)
        }

    }
}

extension MovieViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
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
            
            case MovieType.MOVIE_SHOWTIME.rawValue:
                return tableView.dequeCell(identifier: MovieShowTimeTableViewCell.identifier, indexPath: indexPath)
            case MovieType.MOVIE_GENRE.rawValue:
            let cell = tableView.dequeCell(identifier: GenreTableViewCell.identifier, indexPath: indexPath) as! GenreTableViewCell
            let genreVOList = self.movieGenreList?.genres.map({ genre in
                return genre.converToVO()
            })
            genreVOList?.first?.isSelected = true
            cell.genreList = genreVOList
            return cell
            case MovieType.MOIVE_SHOWCASE.rawValue:
                let cell = tableView.dequeCell(identifier: ShowCaseTableViewCell.identifier, indexPath: indexPath) as! ShowCaseTableViewCell
            cell.data = topRatedMovieList
            return cell
            case MovieType.MOVIE_BESTACTOR.rawValue:
                let cell = tableView.dequeCell(identifier: BestActorTableViewCell.identifier, indexPath: indexPath) as! BestActorTableViewCell
            cell.data = popularPeople
            return cell
            default:
                return UITableViewCell()
            }
        }
}
