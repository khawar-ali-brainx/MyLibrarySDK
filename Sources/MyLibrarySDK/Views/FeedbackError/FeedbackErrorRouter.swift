//
//  File.swift
//
//
//  Created by BrainX 3096 on 28/02/2022.
//

import Foundation

class FeedbackErrorRouter: Router {
    // MARK: - Instance variable

    var viewController: BaseViewController?

    // MARK: - Init Method

    init(viewController: BaseViewController) {
        self.viewController = viewController
    }
}
