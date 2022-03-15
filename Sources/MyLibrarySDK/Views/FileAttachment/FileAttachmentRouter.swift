//
//  FileAttachmentRouter.swift
//
//
//  Created by BrainX 3096 on 26/02/2022.
//

import UIKit

class FileAttachmentRouter: Router {
    // MARK: - Instance variable

    var viewController: BaseViewController?

    // MARK: - Init Method

    init(viewController: BaseViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func presentVC(_ routeType: RouteType, navigationType: NavigationType, animated: Bool, completion: (() -> Void)?) {
        guard let routeType = routeType as? FileAttachmentRouteType else {
            return
        }

        let vc: UIViewController

        switch routeType {
        case .showThankYouView:
            vc = ThankYouViewController()
        }

        switch navigationType {
        case .overlay:
            viewController?.present(vc, animated: animated, completion: completion)
        case .stack:
            viewController?.navigationController?.pushViewController(vc, animated: animated)
        case .root:
            viewController?.navigationController?.viewControllers = [vc]
        }
    }
}
