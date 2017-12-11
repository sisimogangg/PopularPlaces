//
//  RatingView.swift
//  PopularPlaces
//
//  Created by Godfrey Sisimogang on 2017/11/26.
//  Copyright © 2017 Godfrey Sisimogang. All rights reserved.
//

import UIKit

class RatingView: UIStackView {
    
    // MARK: - Properties
    private var starButtons = [UIButton]()
    var rating = 0{
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5{
        didSet {
            setupButtons()
        }
    }
    
    // MARK: - Inits
    override init(frame: CGRect){
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder){
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: - Helpers
    private func setupButtons(){
        // clear any existing buttons
        for button in starButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        starButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<starCount {
            let button = UIButton()
            
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            addArrangedSubview(button)
            starButtons.append(button)
        }
        updateButtonSelectionStates()
    }
    
    
    func ratingButtonTapped(button: UIButton){
        //set rating here bassed on the button clicked
    }
    
    
    // MARK: - Helpers
    private func updateButtonSelectionStates() {
        for (index, button) in starButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
        }
    }
    
    
    
    
    
    
    
}
