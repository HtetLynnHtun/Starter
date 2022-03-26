//
//  MoreContentViewController.swift
//  Starter
//
//  Created by kira on 13/03/2022.
//

import UIKit

class MoreContentViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionViewContent: UICollectionView!
    
    // MARK: - properties
    private let movieModel: MovieModel = MovieModelImpl.shared
    private let personModel: PersonModel = PersonModelImpl.shared
    var contentType: MoreContentType?
    var movieData: [MovieResult] = []
    var movieCurrentPage = 1
    var movieTotalPage = 1
    var actorData: [ActorResult] = []
    var actorCurrentPage = 1
    var actorTotalPage = 1
    var actorSpacing = 12.0
    var movieSpacing = 16.0
    
    // MARK: - view lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        registerCells()
    }
    
    private func initData() {
        if let contentType = contentType {
            switch contentType {
            case .moreMovies(let moreMovies):
                movieData = moreMovies ?? []
                movieTotalPage = movieModel.getTopRatedMoviesTotalPages()
            case .moreActors(let moreActors):
                actorData = moreActors ?? []
                actorTotalPage = personModel.getTotalPages()
            }
        }
    }
    
    // MARK: - cell registrations
    private func registerCells() {
        collectionViewContent.dataSource = self
        collectionViewContent.delegate = self
        if let contentType = contentType {
            switch contentType {
            case .moreMovies:
                collectionViewContent.registerForCell(ShowCaseCollectionViewCell.identifier)
            case .moreActors:
                collectionViewContent.registerForCell(BestActorsCollectionViewCell.identifier)
            }
        }
    }
    
    // MARK: - API methods
    private func fetchMovies(page: Int) {
        movieModel.getTopRatedMovieList(page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movieListResponse):
                self.movieData.append(contentsOf: movieListResponse)
                self.movieTotalPage = self.movieModel.getTopRatedMoviesTotalPages()
                self.collectionViewContent.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchActors(page: Int) {
        personModel.getPopularPeople(page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let moreActors):
                self.actorData.append(contentsOf: moreActors)
                self.actorTotalPage = self.personModel.getTotalPages()
                self.collectionViewContent.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - onTap callbacks
    private func onTapMovie(id: Int) {
        navigateToMovieDetailViewController(id: id, contentType: .movie)
    }
    
    private func onTapActor(id: Int) {
        navigateToActorDetailsViewController(id: id)
    }

}

// MARK: - ViewController extensions
extension MoreContentViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // numbersOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch contentType {
        case .moreMovies:
            return movieData.count
        case .moreActors:
            return actorData.count
        default:
            return 0
        }
    }
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch contentType {
        case .moreMovies:
            let cell = collectionView.dequeCell(identifier: ShowCaseCollectionViewCell.identifier, indexPath: indexPath) as! ShowCaseCollectionViewCell
            cell.data = movieData[indexPath.row]
            return cell
        case .moreActors:
            let cell = collectionView.dequeCell(identifier: BestActorsCollectionViewCell.identifier, indexPath: indexPath) as! BestActorsCollectionViewCell
            cell.data = actorData[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    // didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch contentType {
        case .moreMovies:
            let data = movieData[indexPath.row]
            onTapMovie(id: data.id ?? -1)
        case .moreActors:
            let data = actorData[indexPath.row]
            onTapActor(id: data.id ?? -1)
        default:
            break
        }
    }
    
    // willDisplay
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch contentType {
        case .moreMovies:
            let isLastItem = indexPath.row == (movieData.count - 1)
            let hasMorePage = movieCurrentPage < movieTotalPage
            if (isLastItem && hasMorePage) {
                movieCurrentPage += 1
                fetchMovies(page: movieCurrentPage)
            }
        case .moreActors:
            let isLastItem = indexPath.row == (actorData.count - 1)
            let hasMorePage = actorCurrentPage < actorTotalPage
            if (isLastItem && hasMorePage) {
                actorCurrentPage += 1
                fetchActors(page: actorCurrentPage)
            }
        default:
            break
        }
    }
    
    // sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch contentType {
        case .moreMovies:
            let itemWidth = collectionView.frame.width
            let itemHeight = (itemWidth / 16) * 9
            return CGSize(width: itemWidth, height: itemHeight)
        case .moreActors:
            let itemWidth = (collectionView.frame.width - CGFloat(actorSpacing * 2)) / 3
            let itemHeight = itemWidth * 1.5
            return CGSize(width: itemWidth, height: itemHeight)
        default:
            return CGSize()
        }
    }
    
    // minimumInterItemSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch contentType {
        case .moreMovies:
            return movieSpacing
        case .moreActors:
            return actorSpacing
        default:
            return 0
        }
    }
    
    // minimumLineSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch contentType {
        case .moreMovies:
            return movieSpacing
        case .moreActors:
            return actorSpacing
        default:
            return 0
        }
    }
    
    // insetForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

