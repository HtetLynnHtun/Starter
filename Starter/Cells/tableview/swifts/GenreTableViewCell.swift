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
            genreList?.removeAll(where: { genreVO in
                return movieListByGenre[genreVO.id] == nil
            })
            collectionViewGenre.reloadData()
            onTapGenre(genreId: genreList?.first?.id ?? 0)
        }
    }
    var allMoviesAndSeries: Set<MediaResult>? {
        didSet {
            allMoviesAndSeries?.forEach({ mediaResult in
                mediaResult.genreIDS?.forEach({ genreID in
                    let key = genreID
                    
                    if var _ = movieListByGenre[key] {
                        movieListByGenre[key]!.append(mediaResult)
                    } else {
                        movieListByGenre[key] = [mediaResult]
                    }
                })
            })
        }
    }
    
    weak var delegate: MovieItemDelegate?
    var selectedMovieList: [MediaResult]? = []
    var movieListByGenre: [Int: [MediaResult]] = [:]
    
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
            return selectedMovieList?.count ?? 0
        }
        return genreList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == collectionViewMovie) {
            let cell = collectionView.dequeCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as PopularFilmCollectionViewCell
            cell.data = selectedMovieList?[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeCell(identifier: GenreCollectionViewCell.identifier, indexPath: indexPath) as GenreCollectionViewCell
            cell.data = self.genreList?[indexPath.row]
            cell.onTap = onTapGenre
            return cell
        }
    }
    
    private func onTapGenre(genreId: Int) {
        self.genreList?.forEach { genreVO in
            if (genreVO.id == genreId) {
                genreVO.isSelected = true
            } else {
                genreVO.isSelected = false
            }
        }
        let moviesForCurrentGenre = self.movieListByGenre[genreId]
        self.selectedMovieList = moviesForCurrentGenre
        
        self.collectionViewGenre.reloadData()
        self.collectionViewMovie.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == collectionViewMovie) {
            let media = selectedMovieList?[indexPath.row]
            delegate?.onTapMovie(id: media?.id ?? -1, contentType: media?.contentType ?? .movie)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == collectionViewMovie) {
            let itemWidth = 120.0
            let itemHeight = collectionView.frame.height
            return CGSize(width: itemWidth, height: itemHeight)
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
