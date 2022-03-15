//
//  UIColor.swift
//
//
//  Created by BrainX 3096 on 25/02/2022.
//

import UIKit

public extension UIColor {
    convenience init(_ value: Int) {
        let r = CGFloat(value >> 16 & 0xFF) / 255.0
        let g = CGFloat(value >> 8 & 0xFF) / 255.0
        let b = CGFloat(value & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
