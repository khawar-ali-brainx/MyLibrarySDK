//
//  FloatingButtonRouter.swift
//
//
//  Created by BrainX 3096 on 25/02/2022.
//

import UIKit

class FloatingButtonRouter: Router {
    // MARK: - Instance variable

    var viewController: BaseViewController?

    // MARK: - Init Method

    init(viewController: BaseViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func presentVC(_ routeType: RouteType, navigationType: NavigationType, animated: Bool, completion: (() -> Void)?) {
        guard let routeType = routeType as? FloatingButtonRouteType else {
            return
        }

        let vc: UIViewController

        switch routeType {
        case .languageSelectionView:
            vc = LanguageSelectionViewController()
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
