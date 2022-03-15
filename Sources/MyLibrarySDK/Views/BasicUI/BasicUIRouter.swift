//
//  BasicUIRouter.swift
//
//
//  Created by BrainX 3096 on 25/02/2022.
//

import Foundation

class BasicUIRouter: Router {
    // MARK: - Instance variable

    var viewController: BaseViewController?

    // MARK: - Init Method

    init(viewController: BaseViewController) {
        self.viewController = viewController
    }
}
