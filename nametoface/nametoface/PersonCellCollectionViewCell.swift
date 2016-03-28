//
//  PersonCellCollectionViewCell.swift
//  nametoface
//
//  Created by COM on 2016. 3. 27..
//  Copyright © 2016년 COM. All rights reserved.
//

import UIKit

class PersonCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    var shakeEnabled = false

    
    
    var deleteButton: DeleteButtonView!
    
    func createDeleteButton(){
        deleteButton = DeleteButtonView(frame: CGRect(x: frame.size.width/16, y: frame.size.width/16, width: frame.size.width/4, height: frame.size.width/4))
        
        contentView.addSubview(deleteButton)
    }
    
    func shakeIcons() {
        let shakeAnim = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnim.duration = 0.05
        shakeAnim.repeatCount = 2
        shakeAnim.autoreverses = true
        let startAngle: Float = (-2) * 3.14159/180
        var stopAngle = -startAngle
        shakeAnim.fromValue = NSNumber(float: startAngle)
        shakeAnim.toValue = NSNumber(float: 3 * stopAngle)
        shakeAnim.autoreverses = true
        shakeAnim.duration = 0.2
        shakeAnim.repeatCount = 10000
        shakeAnim.timeOffset = 290 * drand48()
        
        //Create layer, then add animation to the element's layer
        let layer: CALayer = self.layer
        layer.addAnimation(shakeAnim, forKey:"shaking")
        shakeEnabled = true
    }
    
    // This function stop shaking the collection view cells
    func stopShakingIcons() {
        let layer: CALayer = self.layer
        layer.removeAnimationForKey("shaking")
        self.deleteButton.hidden = true
        shakeEnabled = false
    }

    
    
}
