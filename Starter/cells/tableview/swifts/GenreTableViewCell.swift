//
//  GenreTableViewCell.swift
//  Starter
//
//  Created by kira on 09/02/2022.
//

import UIKit

class GenreTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionViewGenre: UICollectionView!
    @IBOutlet weak var collectionViewMovie: UICollectionView!
    
    var genreList: [GenreVO]? {
        didSet {
            if let _ = genreList {
                collectionViewGenre.reloadData()
            }
        }
    }
    var movieList: [MovieResult] = []
    var movieListByGenre: [Int: [MovieResult]] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCollectionViewCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func registerCollectionViewCell() {
        collectionViewGenre.dataSource = self
        collectionViewGenre.delegate = self
        collectionViewGenre.registerForCell(GenreCollectionViewCell.identifier)
        
        collectionViewMovie.dataSource = self
        collectionViewMovie.delegate = self
        collectionViewMovie.registerForCell(PopularFilmCollectionViewCell.identifier)
    }
    
}

extension GenreTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == collectionViewMovie) {
            return movieList.count
        }
        return genreList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == collectionViewMovie) {
            return collectionView.dequeCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath)
        }
        
        let cell = collectionView.dequeCell(identifier: GenreCollectionViewCell.identifier, indexPath: indexPath) as GenreCollectionViewCell
        cell.data = self.genreList?[indexPath.row]
        cell.onTap = { genreId in
            self.genreList?.forEach { genreVO in
                if (genreVO.id == genreId) {
                    genreVO.isSelected = true
                } else {
                    genreVO.isSelected = false
                }
            }
            self.collectionViewGenre.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == collectionViewMovie) {
            return CGSize(width: collectionView.frame.width / 3, height: 225)
        }
       
        let width = sizeOfWidth(text: genreList?[indexPath.row].name ?? "", font: UIFont(name: "Geeza Pro Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)) + 20
        return CGSize(width: width, height: 45)
    }
    
    func sizeOfWidth(text: String, font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let textSize = text.size(withAttributes: fontAttributes)
        return textSize.width
    }
}
