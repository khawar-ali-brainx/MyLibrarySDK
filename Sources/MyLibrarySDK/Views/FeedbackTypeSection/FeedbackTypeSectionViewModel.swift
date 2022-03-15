//
//  FeedbackTypeSectionViewModel.swift
//
//
//  Created by BrainX 3096 on 24/02/2022.
//

import Foundation

class FeedbackTypeSectionViewModel {
    // MARK: - Instance Properties

    private let router: Router

    // MARK: - Init Methods

    required init(router: FeedbackTypeSectionRouter) {
        self.router = router
    }

    // MARK: - Public Methods

    func showCreateFeedbackView(type: FeedbackType) {
        router.presentVC(FeedbackTypeRouteType.createFeedbackView(data: type), navigationType: .stack, animated: false, completion: nil)
    }

    func dismisViewController() {
        router.dismissVC(navigationType: .stack, animated: false, completion: nil)
    }
}
