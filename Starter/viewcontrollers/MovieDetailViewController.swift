//
//  MovieDetailViewController.swift
//  Starter
//
//  Created by kira on 05/02/2022.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var ivBack: UIImageView!
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
    
    let networkAgent = MovieDBNetworkAgent.shared
    var movieId: Int = -1
    var productionCompanies = [ProductionCompany]()
    var casts = [Cast]()
    var similarMovies = [MovieResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        buttonPlayTrailer.tintColor = UIColor(named: "color_primary")
        buttonPlayTrailer.imageView?.tintColor = UIColor(named: "color_primary")
        btnRateMovie.layer.borderColor = CGColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        btnRateMovie.layer.borderWidth = 2

        initGestureRecognizers()
        registerCollectionViewCells()
        setupHeights()
        fetchMovieDetails()
        fetchCredits()
        fetchSimilarMovies()
    }
    
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
    
    func initGestureRecognizers() {
        let tapGestureForBack = UITapGestureRecognizer(target: self, action: #selector(onTapBack))
        ivBack.isUserInteractionEnabled = true
        ivBack.addGestureRecognizer(tapGestureForBack)
    }
    
    @objc func onTapBack() {
        self.dismiss(animated: true)
    }
    
    private func fetchMovieDetails() {
        networkAgent.getMovieDetailsByID(id: movieId) { movieDetailResponse in
            self.bindData(movieDetailResponse)
        } failure: { error in
            print(error)
        }

    }
    
    private func fetchCredits() {
        networkAgent.getMovieCredits(of: movieId) { creditsResponse in
            self.casts = creditsResponse.cast ?? []
            self.collectionViewActors.reloadData()
        } failure: { error in
            print(error)
        }
    }
    
    private func fetchSimilarMovies() {
        networkAgent.getSimilarMovies(id: movieId) { movieListResponse in
            self.similarMovies = movieListResponse.results ?? []
            self.collectionViewSimilarContents.reloadData()
        } failure: { error in
            print(error)
        }
    }
    
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
        labelType.text = data.genres?.map({ $0.name }).joined(separator: ", ")
        labelProduction.text = data.productionCountries?.map({ $0.name ?? "" }).joined(separator: ", ")
        labelReleaseDate.text = data.releaseDate
        lableDescription.text = data.overview
    }
    
    private func readableRuntime(_ time: Int) -> String{
        let hour = time / 60
        let minutes = time % 60
        return "\(hour)hr \(minutes)mins"
    }
    
    private func setupHeights() {
        let itemWidth = collectionViewActors.frame.width / 2.5
        let itemHeight = itemWidth * 1.5
        heightOfCollectionViewActors.constant = itemHeight
    }
}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == collectionViewProductionCompanies) {
            return productionCompanies.count
        } else if (collectionView == collectionViewActors) {
            return casts.count
        } else {
            return similarMovies.count
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
            cell.data = similarMovies[indexPath.row].toMediaResult()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == collectionViewProductionCompanies) {
            let itemWidth = 200
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
