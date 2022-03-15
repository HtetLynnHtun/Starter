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
    @IBOutlet weak var heightOfCollectionViewBestActors: NSLayoutConstraint!
    
    var data: ActorListResponse? {
        didSet {
            if let _ = data {
                collectionViewBestActors.reloadData()
                labelMoreActors.isUserInteractionEnabled = true
            }
        }
    }
    
    var onTapMore: ((_ contentType: MoreContentType) -> Void) = {contentType in }
    var onTapActor: ((_ id: Int) -> Void) = {id in}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelMoreActors.underlineText(text: "MORE ACTORS")
        
        registerCollectionViewCell()
        setupHeights()
        setupGestureRecognizers()
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
    
    private func setupHeights() {
        let itemWidth = collectionViewBestActors.frame.width / 2.5
        let itemHeight = itemWidth * 1.5
        heightOfCollectionViewBestActors.constant = itemHeight
    }
    
    private func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapMoreHandler))
        labelMoreActors.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func onTapMoreHandler() {
        onTapMore(.moreActors(data))
    }
}

extension BestActorTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ActorActionDelegate {
    
    func onTapFavorite(isFavorite: Bool) {
        debugPrint("isFavorite: \(isFavorite)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(identifier: BestActorsCollectionViewCell.identifier, indexPath: indexPath) as BestActorsCollectionViewCell
        cell.delegate = self
        cell.data = data?.results?[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let actor = data?.results?[indexPath.row]
        onTapActor(actor?.id ?? -1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.frame.width / 2.5
        let itemHeight = itemWidth * 1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
