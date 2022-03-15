//
//  UIImage.swift
//
//
//  Created by BrainX 3096 on 24/02/2022.
//

import UIKit

extension UIImage {
    enum SupportedImageType: String {
        case png
        case pdf
    }

    convenience init?(packageResource name: String, ofType type: SupportedImageType) {
        #if canImport(UIKit)
            guard let path = Bundle.module.path(forResource: name, ofType: type.rawValue) else {
                let bundle = Bundle(for: FeedbackWindow.self)
                self.init(named: name, in: bundle, compatibleWith: nil)
                return
            }
            self.init(contentsOfFile: path)
        #else
            self.init(name)
        #endif
    }
}
