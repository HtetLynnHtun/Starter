//
//  RatingControl.swift
//  Starter
//
//  Created by kira on 08/02/2022.
//

import UIKit

@IBDesignable
class RatingControl: UIStackView {
    
    @IBInspectable var starSize: CGSize = CGSize(width: 16.0, height: 16.0) {
        didSet {
            setUpButtons()
            updateButtonRating()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setUpButtons()
            updateButtonRating()
        }
    }
    @IBInspectable var rating: Int = 3 {
        didSet {
            updateButtonRating()
        }
    }
    
    var ratingButtons = [UIButton]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButtons()
        updateButtonRating()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpButtons()
        updateButtonRating()
    }
    
    
    private func setUpButtons() {
        clearExistingButtons()
        for _ in 0..<starCount {
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: "filledStar"), for: .selected)
            button.setBackgroundImage(UIImage(named: "emptyStar"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            button.isUserInteractionEnabled = false
            button.isSelected = true
            ratingButtons.append(button)
            
            addArrangedSubview(button)
        }
    }
    
    private func updateButtonRating() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
    
    private func clearExistingButtons() {
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
    }
}
