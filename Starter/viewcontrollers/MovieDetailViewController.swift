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
    
    @IBOutlet weak var btnRateMovie: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btnRateMovie.layer.borderColor = CGColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        btnRateMovie.layer.borderWidth = 2

        initGestureRecognizers()
        collectionViewActors.dataSource = self
        collectionViewActors.delegate = self
        collectionViewActors.registerForCell(BestActorsCollectionViewCell.identifier)
    }
    
    func initGestureRecognizers() {
        let tapGestureForBack = UITapGestureRecognizer(target: self, action: #selector(onTapBack))
        ivBack.isUserInteractionEnabled = true
        ivBack.addGestureRecognizer(tapGestureForBack)
    }
    
    @objc func onTapBack() {
        self.dismiss(animated: true)
    }
}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeCell(identifier: BestActorsCollectionViewCell.identifier, indexPath: indexPath) as? BestActorsCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.5, height: 220)
    }
    
}
