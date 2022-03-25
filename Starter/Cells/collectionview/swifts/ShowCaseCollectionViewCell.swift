//
//  ShowCaseCollectionViewCell.swift
//  Starter
//
//  Created by kira on 09/02/2022.
//

import UIKit

class ShowCaseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelContentTitle: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var releaseDateView: UILabel!
    
    var data: MovieResult? {
        didSet {
            if let data = data {
                let title = data.originalTitle
                let releaseDate = data.releaseDate
                let backdropPath = "\(AppConstants.baseImageURL)/\(data.backdropPath ?? "")"
                
                labelContentTitle.text = title
                releaseDateView.text = releaseDate
                backdropImageView.sd_setImage(with: URL(string: backdropPath))
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
