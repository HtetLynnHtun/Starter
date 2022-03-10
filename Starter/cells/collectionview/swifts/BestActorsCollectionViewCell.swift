//
//  BestActorsCollectionViewCell.swift
//  Starter
//
//  Created by kira on 10/02/2022.
//

import UIKit

class BestActorsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ivHeartFill: UIImageView!
    @IBOutlet weak var ivHeart: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    
    var delegate: ActorActionDelegate? = nil
    var data: ActorResult? {
        didSet {
            if let data = data {
                let name = data.name
                let department = data.knownForDepartment
                let profilePath = "\(AppConstants.baseImageURL)/\(data.profilePath ?? "")"
                
                nameLabel.text = name
                departmentLabel.text = department
                imageProfile.sd_setImage(with: URL(string: profilePath))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initGestureRecognizers()
    }

    private func initGestureRecognizers() {
        let tapGestureForFavorite = UITapGestureRecognizer(target: self, action: #selector(onTapFavorite))
        ivHeartFill.isUserInteractionEnabled = true
        ivHeartFill.addGestureRecognizer(tapGestureForFavorite)
        
        let tapGestureForUnFavorite = UITapGestureRecognizer(target: self, action: #selector(onTapUnFavorite))
        ivHeart.isUserInteractionEnabled = true
        ivHeart.addGestureRecognizer(tapGestureForUnFavorite)
    }
    
    @objc func onTapFavorite() {
        ivHeartFill.isHidden = true
        ivHeart.isHidden = false
        delegate?.onTapFavorite(isFavorite: true)
    }
    
    @objc func onTapUnFavorite() {
        ivHeart.isHidden = true
        ivHeartFill.isHidden = false
        delegate?.onTapFavorite(isFavorite: false)
    }
}
