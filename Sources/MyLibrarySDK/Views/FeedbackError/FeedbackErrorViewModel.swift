//
//  File.swift
//
//
//  Created by BrainX 3096 on 28/02/2022.
//

import Foundation

class FeedbackErrorViewModel {
    // MARK: - Instance Properties

    private let router: Router

    // MARK: - Init Methods

    required init(router: FeedbackErrorRouter) {
        self.router = router
    }

    func dismisViewController() {
        router.dismissVC(navigationType: .stack, animated: false, completion: nil)
    }
}
