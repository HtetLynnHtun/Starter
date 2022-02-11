//
//  BestActorTableViewCell.swift
//  Starter
//
//  Created by kira on 10/02/2022.
//

import UIKit

class BestActorTableViewCell: UITableViewCell {

    @IBOutlet weak var labelMoreActors: UILabel!
    @IBOutlet weak var collectionViewBestActors: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelMoreActors.underlineText(text: "MORE ACTORS")
        
        registerCollectionViewCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func registerCollectionViewCell() {
        collectionViewBestActors.dataSource = self
        collectionViewBestActors.delegate = self
        collectionViewBestActors.registerForCell(BestActorsCollectionViewCell.identifier)
    }
}

extension BestActorTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ActorActionDelegate {
    
    func onTapFavorite(isFavorite: Bool) {
        debugPrint("isFavorite: \(isFavorite)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(identifier: BestActorsCollectionViewCell.identifier, indexPath: indexPath) as BestActorsCollectionViewCell
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.5, height: 200)
    }
}
