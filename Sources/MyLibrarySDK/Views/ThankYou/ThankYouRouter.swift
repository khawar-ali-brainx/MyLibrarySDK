//
//  File.swift
//
//
//  Created by BrainX 3096 on 26/02/2022.
//

import Foundation

class ThankYouRouter: Router {
    // MARK: - Instance variable

    var viewController: BaseViewController?

    // MARK: - Init Method

    init(viewController: BaseViewController) {
        self.viewController = viewController
    }
}
