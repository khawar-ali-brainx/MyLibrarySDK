//
//  CreateFeedbackRouter.swift
//
//
//  Created by BrainX 3096 on 24/02/2022.
//

import Foundation
import UIKit

class CreateFeedbackRouter: Router {
    // MARK: - Instance variable

    var viewController: BaseViewController?

    // MARK: - Init Method

    init(viewController: BaseViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func presentVC(_ routeType: RouteType, navigationType: NavigationType, animated: Bool, completion: (() -> Void)?) {
        guard let routeType = routeType as? CreateFeedbackRouteType else {
            return
        }

        let vc: UIViewController

        switch routeType {
        case .showFileAttachmentView:
            vc = FileAttachmentViewController()
        case let .showErrorView(data: data):
            let controller = FeedbackErrorViewController()
            let error = data as? ErrorMessageAndTitle
            controller.errorTitle = error?.errorTitle
            controller.descriptionMessage = error?.errorDescription
            vc = controller
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
