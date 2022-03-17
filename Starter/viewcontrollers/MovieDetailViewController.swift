//
//  MovieDetailViewController.swift
//  Starter
//
//  Created by kira on 05/02/2022.
//

import UIKit

class MovieDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionViewActors: UICollectionView!
    @IBOutlet weak var collectionViewProductionCompanies: UICollectionView!
    @IBOutlet weak var buttonPlayTrailer: UIButton!
    @IBOutlet weak var collectionViewSimilarContents: UICollectionView!
    @IBOutlet weak var heightOfCollectionViewActors: NSLayoutConstraint!
    @IBOutlet weak var btnRateMovie: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageBackdrop: UIImageView!
    @IBOutlet weak var labelReleaseYear: UILabel!
    @IBOutlet weak var labelVotes: UILabel!
    @IBOutlet weak var ratingStar: RatingControl!
    @IBOutlet weak var labelVoteAverage: UILabel!
    @IBOutlet weak var labelRuntime: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    @IBOutlet weak var labelOriginalTitle: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelProduction: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var lableDescription: UILabel!
    
    // MARK: - Properties
    let networkAgent = AlamofireNetworkAgent.shared
    var contentType: DetailContentType = .movie
    var contentId: Int = -1
    var productionCompanies = [ProductionCompany]()
    var casts = [Cast]()
    var similarMovies = [MovieResult]()
    var similarSeries = [SeriesResult]()
    var trailers = [TrailerResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupViews()
        registerCollectionViewCells()
        setupHeights()
        fetchContentDetails()
    }
    
    // MARK: - Views setup
    private func setupViews() {
        buttonPlayTrailer.isHidden = true
        buttonPlayTrailer.tintColor = UIColor(named: "color_primary")
        buttonPlayTrailer.imageView?.tintColor = UIColor(named: "color_primary")
        btnRateMovie.layer.borderColor = CGColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        btnRateMovie.layer.borderWidth = 2
    }
    
    private func setupHeights() {
        let itemWidth = collectionViewActors.frame.width / 2.5
        let itemHeight = itemWidth * 1.5
        heightOfCollectionViewActors.constant = itemHeight
    }
    
    // MARK: - Cell registrations
    func registerCollectionViewCells() {
        collectionViewActors.dataSource = self
        collectionViewActors.delegate = self
        collectionViewActors.registerForCell(BestActorsCollectionViewCell.identifier)
        
        collectionViewSimilarContents.dataSource = self
        collectionViewSimilarContents.delegate = self
        collectionViewSimilarContents.registerForCell(PopularFilmCollectionViewCell.identifier)
        
        collectionViewProductionCompanies.dataSource = self
        collectionViewProductionCompanies.delegate = self
        collectionViewProductionCompanies.registerForCell(ProductionCompanyCollectionViewCell.identifier)
    }
    
    // MARK: - API methods
    private func fetchContentDetails() {
        switch contentType {
        case .movie:
            fetchMovieDetails()
            fetchMovieTrailers()
            fetchCredits()
            fetchSimilarMovies()
        case .series:
            fetchSeriesDetails()
            fetchSeriesTrailers()
            fetchSeriesCredits()
            fetchSimilarSeriess()
        }
    }
    
    // MARK: - API methods - movie
    private func fetchMovieDetails() {
        networkAgent.getMovieDetailsByID(id: contentId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movieDetailResponse):
                self.bindData(movieDetailResponse)
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    private func fetchCredits() {
        networkAgent.getMovieCredits(of: contentId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let creditsResponse):
                self.casts = creditsResponse.cast ?? []
                self.collectionViewActors.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchSimilarMovies() {
        networkAgent.getSimilarMovies(id: contentId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movieListResponse):
                self.similarMovies = movieListResponse.results ?? []
                self.collectionViewSimilarContents.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchMovieTrailers() {
        networkAgent.getMovieTrailers(id: contentId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let trailersResponse):
                self.trailers = trailersResponse.results ?? []
                if !self.trailers.isEmpty {
                    self.buttonPlayTrailer.isHidden = false
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - API methods - series
    private func fetchSeriesDetails() {
        networkAgent.getSeriesDetailsByID(id: contentId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let seriesDetailResponse):
                self.bindData(seriesDetailResponse)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchSeriesTrailers() {
        networkAgent.getSeriesTrailers(id: contentId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let trailersResponse):
                self.trailers = trailersResponse.results ?? []
                if !self.trailers.isEmpty {
                    self.buttonPlayTrailer.isHidden = false
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchSeriesCredits() {
        networkAgent.getSeriesCredits(of: contentId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let creditsResponse):
                self.casts = creditsResponse.cast ?? []
                self.collectionViewActors.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchSimilarSeriess() {
        networkAgent.getSimilarSeries(id: contentId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let seriesListResponse):
                self.similarSeries = seriesListResponse.results ?? []
                self.collectionViewSimilarContents.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Data bindings
    private func bindData(_ data: MovieDetailResponse) {
        productionCompanies = data.productionCompanies ?? []
        collectionViewProductionCompanies.reloadData()
        
        let backdropPath = "\(AppConstants.baseImageURL)/\(data.backdropPath ?? "")"
        imageBackdrop.sd_setImage(with: URL(string: backdropPath))
        labelTitle.text = data.title
        labelReleaseYear.text = String(data.releaseDate?.split(separator: "-")[0] ?? "")
        labelVotes.text = "\(data.voteCount ?? 0) VOTES"
        ratingStar.rating = Int((data.voteAverage ?? 0.0) * 0.5)
        labelVoteAverage.text = "\(data.voteAverage ?? 0.0)"
        labelRuntime.text = readableRuntime(data.runtime ?? 0)
        labelOverview.text = data.overview
        labelOriginalTitle.text = data.originalTitle
        navigationItem.title = data.originalTitle
        labelType.text = data.genres?.map({ $0.name }).joined(separator: ", ")
        labelProduction.text = data.productionCountries?.map({ $0.name ?? "" }).joined(separator: ", ")
        labelReleaseDate.text = data.releaseDate
        lableDescription.text = data.overview
    }
    
    private func bindData(_ data: SeriesDetailResponse) {
        productionCompanies = data.productionCompanies ?? []
        collectionViewProductionCompanies.reloadData()
        
        let backdropPath = "\(AppConstants.baseImageURL)/\(data.backdropPath ?? "")"
        imageBackdrop.sd_setImage(with: URL(string: backdropPath))
        labelTitle.text = data.name
        labelReleaseYear.text = String(data.firstAirDate?.split(separator: "-")[0] ?? "")
        labelVotes.text = "\(data.voteCount ?? 0) VOTES"
        ratingStar.rating = Int((data.voteAverage ?? 0.0) * 0.5)
        labelVoteAverage.text = "\(data.voteAverage ?? 0.0)"
        labelRuntime.text = readableRuntime(data.episodeRunTime?.first ?? 0)
        labelOverview.text = data.overview
        labelOriginalTitle.text = data.originalName
        labelType.text = data.genres?.map({ $0.name }).joined(separator: ", ")
        labelProduction.text = data.productionCountries?.map({ $0.name ?? "" }).joined(separator: ", ")
        labelReleaseDate.text = data.firstAirDate
        lableDescription.text = data.overview
    }
    
    private func readableRuntime(_ time: Int) -> String{
        let hour = time / 60
        let minutes = time % 60
        return "\(hour)hr \(minutes)mins"
    }
    
    // MARK: - Callbacks for onTap
    @IBAction func onTapTrailer(_ sender: UIButton) {
        let youtubeId = trailers.first { trailerResult in
            trailerResult.site == "YouTube"
        }?.key
        let playerVC = YoutubePlayerViewController()
        playerVC.youtubeId = youtubeId
        self.present(playerVC, animated: true)
    }

    func onTapActor(id: Int) {
        navigateToActorDetailsViewController(id: id)
    }
    
    func onTapMovie(id: Int) {
        navigateToMovieDetailViewController(id: id, contentType: .movie)
    }
    
    func onTapSeries(id: Int) {
        navigateToMovieDetailViewController(id: id, contentType: .series)
    }
}

// MARK: - ViewController extensions
extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == collectionViewProductionCompanies) {
            return productionCompanies.count
        } else if (collectionView == collectionViewActors) {
            return casts.count
        } else {
            switch contentType {
            case .movie:
                return similarMovies.count
            case .series:
                return similarSeries.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == collectionViewProductionCompanies) {
            guard let cell = collectionView.dequeCell(identifier: ProductionCompanyCollectionViewCell.identifier, indexPath: indexPath) as? ProductionCompanyCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.data = productionCompanies[indexPath.row]
            return cell
        } else if (collectionView == collectionViewActors) {
            guard let cell = collectionView.dequeCell(identifier: BestActorsCollectionViewCell.identifier, indexPath: indexPath) as? BestActorsCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.data = casts[indexPath.row].toActorResult()
            return cell
        } else {
            guard let cell = collectionView.dequeCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as? PopularFilmCollectionViewCell else {
                return UICollectionViewCell()
            }
            switch contentType {
            case .movie:
                cell.data = similarMovies[indexPath.row].toMediaResult()
            case .series:
                cell.data = similarSeries[indexPath.row].toMediaResult()
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == collectionViewActors) {
            let actor = casts[indexPath.row]
            onTapActor(id: actor.id ?? -1)
        } else if (collectionView == collectionViewSimilarContents) {
            switch contentType {
            case .movie:
                let movie = similarMovies[indexPath.row]
                onTapMovie(id: movie.id ?? -1)
            case .series:
                let series = similarSeries[indexPath.row]
                onTapSeries(id: series.id ?? -1)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == collectionViewProductionCompanies) {
            let itemWidth = collectionView.frame.height
            let itemHeight = itemWidth
            return CGSize(width: itemWidth, height: itemHeight)
        } else if (collectionView == collectionViewActors) {
            let itemWidth = collectionView.frame.width / 2.5
            let itemHeight = itemWidth * 1.5
            return CGSize(width: itemWidth, height: itemHeight)
        } else {
            let itemWidth = 120.0
            let itemHeight = collectionView.frame.height
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
}
