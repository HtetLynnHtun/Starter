//
//  PopularSeriesTableViewCell.swift
//  Starter
//
//  Created by kira on 11/03/2022.
//

import UIKit

class PopularSeriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionViewSeries: UICollectionView!
    
    var data: SeriesListResponse? {
        didSet {
            if let _ = data {
                collectionViewSeries.reloadData()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCollectionViewCell()
    }

    private func registerCollectionViewCell() {
        collectionViewSeries.dataSource = self
        collectionViewSeries.delegate = self
        collectionViewSeries.registerForCell(PopularFilmCollectionViewCell.identifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension PopularSeriesTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as! PopularFilmCollectionViewCell
        cell.data = data?.results?[indexPath.row].toMediaResult()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: 225)
    }
    
}
