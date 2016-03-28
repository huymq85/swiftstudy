//
//  RatingControl.swift
//  testswift
//
//  Created by COM on 2016. 2. 18..
//  Copyright © 2016년 COM. All rights reserved.
//

import UIKit

class RatingControl: UIView {
    
    // MARK: Properties
    
    var rating = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    var ratingButtons = [UIButton]()
    
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let emptyStarImage = UIImage(named: "emptyStar")
        let filledStarImage = UIImage(named: "filledStar")
        
        for _ in 0..<5 {
            let button = UIButton()
            
            button.setImage(emptyStarImage, forState: .Normal)
            button.setImage(filledStarImage, forState: .Selected)
            button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
            
            button.adjustsImageWhenHighlighted = false
            
            button.addTarget(self, action: "ratingButtonTapped:", forControlEvents: .TouchDown)
            ratingButtons += [button]
            addSubview(button)
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize + 5) * 5
        
        return CGSize(width: width, height: buttonSize)
    }
    
    // MARK: Button Action
    
    override func layoutSubviews() {
        // Set the button's width and height to a square the size of the frame's height.
        let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        // Offset each button's origin by the length of the button plus some spacing.
        for (index, button) in ratingButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + 5))
            button.frame = buttonFrame
        }
        
        updateButtonSelectionStates()
    }
    
    func ratingButtonTapped(button: UIButton) {
        rating = ratingButtons.indexOf(button)! + 1
        
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerate() {
            // If the index of a button is less than the rating, that button shouldn't be selected.
            button.selected = index < rating
        }
    }
    

}
