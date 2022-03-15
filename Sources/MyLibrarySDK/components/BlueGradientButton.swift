//
//  BlueGradientButton.swift
//
//
//  Created by BrainX 3096 on 25/02/2022.
//

import UIKit

class BlueGradientButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [Color.blueGradientFirstColor.cgColor, Color.blueGradientSecondColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }()
}
