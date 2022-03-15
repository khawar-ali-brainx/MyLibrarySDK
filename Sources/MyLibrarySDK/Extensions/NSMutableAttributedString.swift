//
//  NSMutableAttributedString.swift
//
//
//  Created by BrainX 3096 on 26/02/2022.
//

import UIKit

extension NSMutableAttributedString {
    func custom(_ value: String, font: UIFont, color: UIColor) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
        ]
        append(NSAttributedString(string: value, attributes: attributes))
        return self
    }

    func underLine(_ value: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
}
