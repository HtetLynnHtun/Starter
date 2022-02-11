//
//  ShowCaseTableViewCell.swift
//  Starter
//
//  Created by kira on 09/02/2022.
//

import UIKit

class ShowCaseTableViewCell: UITableViewCell {

    @IBOutlet weak var labelMore: UILabel!
    @IBOutlet weak var collectionViewShowCase: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        labelMore.underlineText(text: "MORE SHOWCASES")
        
        registerCollectionViewCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func registerCollectionViewCell() {
        collectionViewShowCase.dataSource = self
        collectionViewShowCase.delegate = self
        collectionViewShowCase.registerForCell(ShowCaseCollectionViewCell.identifier)
    }
}

extension ShowCaseTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeCell(identifier: ShowCaseCollectionViewCell.identifier, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 50, height: 180)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // get horizontal scroll indicator view and change it's  background
        scrollView.subviews.last?.subviews[0].backgroundColor = UIColor(named: "color_yellow")
    }
}
