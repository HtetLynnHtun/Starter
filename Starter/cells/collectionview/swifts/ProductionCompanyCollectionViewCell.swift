//
//  ProductionCompanyCollectionViewCell.swift
//  Starter
//
//  Created by kira on 11/03/2022.
//

import UIKit

class ProductionCompanyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    var data: ProductionCompany? {
        didSet {
            if let data = data {
                print(data)
                let logoPath = "\(AppConstants.baseImageURL)/\(data.logoPath ?? "")"
                imageLogo.sd_setImage(with: URL(string: logoPath))
                labelName.text = data.name
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
