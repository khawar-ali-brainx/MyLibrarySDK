//
//  LanguageSelectionRouter.swift
//
//
//  Created by BrainX 3096 on 25/02/2022.
//

import UIKit

class LanguageSelectionRouter: Router {
    // MARK: - Instance variable

    var viewController: BaseViewController?

    // MARK: - Init Method

    init(viewController: BaseViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Method

    func presentVC(_ routeType: RouteType, navigationType: NavigationType, animated: Bool, completion: (() -> Void)?) {
        guard let routeType = routeType as? LanguageSelectionRouteType else {
            return
        }

        let vc: UIViewController

        switch routeType {
        case .feedbackTypeView:
            vc = FeedbackTypeSectionViewController()
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
