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
                let logoPath = "\(AppConstants.baseImageURL)/\(data.logoPath ?? "")"
                imageLogo.sd_setImage(with: URL(string: logoPath))
                
                if (data.logoPath == nil || data.logoPath!.isEmpty) {
                    labelName.text = data.name
                } else {
                    labelName.text = ""
                }
                
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
