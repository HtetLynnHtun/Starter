//
//  PopularFilmCollectionViewCell.swift
//  Starter
//
//  Created by kira on 09/02/2022.
//

import UIKit

class PopularFilmCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var labelContentTitle: UILabel!
    @IBOutlet weak var labelRating: UITextView!
    @IBOutlet weak var ratingStar: RatingControl!
    
    var data: MovieResult? {
        didSet {
            if let data = data {
                let posterPath = "\(AppConstants.baseImageURL)/\(data.posterPath ?? "")"
                let title = data.originalTitle
                let voteAverage = data.voteAverage ?? 0.0
                
                imageViewPoster.sd_setImage(with: URL(string: posterPath))
                labelContentTitle.text = title
                labelRating.text = "\(voteAverage)"
                ratingStar.rating = Int(voteAverage * 0.5)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
