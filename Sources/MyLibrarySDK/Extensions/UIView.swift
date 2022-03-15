//
//  File.swift
//  
//
//  Created by BrainX 3096 on 14/03/2022.
//

import Foundation
import UIKit

extension UIView {
    func setBorderColor(_ color: UIColor, andWidth width: CGFloat = 1.0) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }

    func setCornerRadius(_ r: CGFloat, andClipContent clip: Bool = true) {
        layer.cornerRadius = r
        layer.masksToBounds = clip
    }
    
    func addDropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
