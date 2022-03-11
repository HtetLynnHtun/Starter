//
//  PopularFilmTableViewCell.swift
//  Starter
//
//  Created by kira on 09/02/2022.
//

import UIKit

class PopularFilmTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionViewMovies: UICollectionView!
    var delegate: MovieItemDelegate? = nil
    var data: MovieListResponse? {
        didSet {
            collectionViewMovies.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCollectionViewCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func registerCollectionViewCell() {
        collectionViewMovies.dataSource = self
        collectionViewMovies.delegate = self
        collectionViewMovies.registerForCell(PopularFilmCollectionViewCell.identifier)
    }
}

extension PopularFilmTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as! PopularFilmCollectionViewCell
        cell.data = self.data?.results?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = self.data?.results?[indexPath.row]
        delegate?.onTapMovie(id: movie?.id ?? -1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: 225)
    }
}
