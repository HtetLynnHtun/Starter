//
//  GenreCollectionViewCell.swift
//  Starter
//
//  Created by kira on 09/02/2022.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelGenre: UILabel!
    @IBOutlet weak var viewForOverLay: UIView!
    
    var onTap: ((String) -> Void) = {_ in}
    
    var data: GenreVO? = nil {
        didSet {
            if let genre = data {
                labelGenre.text = genre.name
                genre.isSelected ? (viewForOverLay.isHidden = false) : (viewForOverLay.isHidden = true)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureForContainer = UITapGestureRecognizer(target: self, action: #selector(didTapItem))
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tapGestureForContainer)
    }
    
    @objc func didTapItem() {
        onTap(data?.name ?? "")
    }

}
