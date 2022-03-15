//
//  ActorDetailsViewController.swift
//  Starter
//
//  Created by kira on 14/03/2022.
//

import UIKit

class ActorDetailsViewController: UIViewController {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelBirthday: UILabel!
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var labelBiography: UILabel!
    @IBOutlet weak var buttonReadMore: UIButton!
    @IBOutlet weak var collectionViewCredits: UICollectionView!
    
    let networkAgent = MovieDBNetworkAgent.shared
    var actorID: Int = 1
    var homepageUrl: String?
    var creditsData = [MovieOrTV]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCells()
        fetchDetails()
        fetchCombinedCredits()
    }
    
    private func setupUI() {
        buttonReadMore.isHidden = true
    }
    
    private func registerCells() {
        collectionViewCredits.dataSource = self
        collectionViewCredits.delegate = self
        collectionViewCredits.registerForCell(PopularFilmCollectionViewCell.identifier)
    }
    
    private func fetchDetails() {
        networkAgent.getPersonDetailsByID(of: actorID) { actorDetailResponse in
            self.bindData(actorDetailResponse)
        } failure: { error in
            print(error)
        }

    }
    
    private func fetchCombinedCredits() {
        networkAgent.getCombinedCredits(of: actorID) { actorCreditsResponse in
            self.creditsData = actorCreditsResponse.results ?? []
            self.collectionViewCredits.reloadData()
        } failure: { error in
            print(error)
        }

    }
    
    private func bindData(_ data: ActorDetailResponse) {
        labelName.text = data.name ?? ""
        labelBirthday.text = data.birthday ?? ""
        labelBiography.text = data.biography ?? ""
        
        let posterPath = "\(AppConstants.baseImageURL)/\(data.profilePath ?? "")"
        imagePoster.sd_setImage(with: URL(string: posterPath))
        
        if let homepage = data.homepage {
            homepageUrl = homepage
            buttonReadMore.isHidden = false
        }
    }
    
    @IBAction func onTapReadMore(_ sender: UIButton) {
        if let homepageUrl = homepageUrl {
            let url = URL(string: homepageUrl)!
            UIApplication.shared.open(url)
        }
    }

    @IBAction func onTapBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func onTapItem(id: Int, contentType: DetailContentType) {
        navigateToMovieDetailViewController(id: id, contentType: contentType)
    }
}

extension ActorDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return creditsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as! PopularFilmCollectionViewCell
        cell.data = creditsData[indexPath.row].toMediaResult()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = creditsData[indexPath.row].toMediaResult()
        onTapItem(id: data.id ?? -1, contentType: data.contentType)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = 120.0
        let itemHeight = collectionView.frame.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
