//
//  MovieShowTimeTableViewCell.swift
//  Starter
//
//  Created by kira on 09/02/2022.
//

import UIKit

class MovieShowTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var viewForBackground: UIView!
    @IBOutlet weak var labelSeeMore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewForBackground.layer.cornerRadius = 4
        
        labelSeeMore.underlineText(text: "SEE MORE")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
