//
//  UIButton.swift
//
//
//  Created by BrainX 3096 on 24/02/2022.
//

import UIKit

extension UIButton {
    func addRightIcon(_ icon: UIImage, withSize size: CGSize = CGSize(width: 20, height: 20)){
        let imageView = UIImageView(image: icon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        subviews.first(where: { $0.tag == 101 })?.removeFromSuperview()
        imageView.tag = 101
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            imageView.centerYAnchor.constraint(equalTo: titleLabel!.centerYAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: size.width),
            imageView.heightAnchor.constraint(equalToConstant: size.height),
        ])
    }

    func addLeftIcon(_ icon: UIImage, withSize size: CGSize = CGSize(width: 24, height: 24)){
        let imageView = UIImageView(image: icon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        subviews.first(where: { $0.tag == 101 })?.removeFromSuperview()
        imageView.tag = 101
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: titleLabel!.leadingAnchor, constant: -8),
            imageView.centerYAnchor.constraint(equalTo: titleLabel!.centerYAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: size.width),
            imageView.heightAnchor.constraint(equalToConstant: size.height),
        ])
    }
}
