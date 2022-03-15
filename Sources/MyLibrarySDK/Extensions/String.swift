//
//  String.swift
//
//
//  Created by BrainX 3096 on 24/02/2022.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.module, value: "", comment: self)
    }
}

#if !SPM
extension Bundle {
    static var module:Bundle { Bundle(for: FeedbackWindow.self) }
}
#endif
