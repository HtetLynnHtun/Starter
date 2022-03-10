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
    private var data: UpcomingMovieList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
        fetchUpcomingMovieList()
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
            self.data = upcomingMovieList
            self.tableViewMovies.reloadSections(
                IndexSet(integer: MovieType.MOVIE_SLIDER.rawValue),
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
            cell.data = data
            return cell
            
            case MovieType.MOVIE_POPULAR.rawValue:
            let cell = tableView.dequeCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
            cell.delegate = self
            return cell
            
            case MovieType.MOVIE_SHOWTIME.rawValue:
                return tableView.dequeCell(identifier: MovieShowTimeTableViewCell.identifier, indexPath: indexPath)
            case MovieType.MOVIE_GENRE.rawValue:
                return tableView.dequeCell(identifier: GenreTableViewCell.identifier, indexPath: indexPath)
            case MovieType.MOIVE_SHOWCASE.rawValue:
                return tableView.dequeCell(identifier: ShowCaseTableViewCell.identifier, indexPath: indexPath)
            case MovieType.MOVIE_BESTACTOR.rawValue:
                return tableView.dequeCell(identifier: BestActorTableViewCell.identifier, indexPath: indexPath)
            default:
                return UITableViewCell()
            }
        }
}
