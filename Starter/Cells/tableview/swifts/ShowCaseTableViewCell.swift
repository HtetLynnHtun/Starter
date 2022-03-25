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
    @IBOutlet weak var heightOfCollectionViewShowCase: NSLayoutConstraint!
    
    var data: [MovieResult]? {
        didSet {
            if let _ = data {
                collectionViewShowCase.reloadData()
                labelMore.isUserInteractionEnabled = true
            }
        }
    }
    
    weak var delegate: MovieItemDelegate?
    var onTapMore: ((_ contentType: MoreContentType) -> Void) = {contentType in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        labelMore.underlineText(text: "MORE SHOWCASES")
        labelMore.isUserInteractionEnabled = false
        
        registerCollectionViewCell()
        setupGestureRecognizers()
        setupHeights()
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
    
    func setupHeights() {
        let itemWidth = collectionViewShowCase.frame.width - 50
        let itemHeight = (itemWidth / 16) * 9
        heightOfCollectionViewShowCase.constant = itemHeight + 50
    }
    
    private func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapMoreHandler))
        labelMore.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func onTapMoreHandler() {
//        onTapMore(.moreMovies(data))
    }
}

extension ShowCaseTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(identifier: ShowCaseCollectionViewCell.identifier, indexPath: indexPath) as! ShowCaseCollectionViewCell
        cell.data = data?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionViewShowCase.frame.width - 50
        let itemHeight = (itemWidth / 16) * 9
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // get horizontal scroll indicator view and change it's  background
        scrollView.subviews.last?.subviews[0].backgroundColor = UIColor(named: "color_yellow")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let media = data?[indexPath.row]
        delegate?.onTapMovie(id: media?.id ?? -1, contentType: .movie)
    }
}
