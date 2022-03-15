//
//  CreateFeedbackViewModel.swift
//
//
//  Created by BrainX 3096 on 24/02/2022.
//

import Foundation
import UIKit

class CreateFeedbackViewModel {
    // MARK: - Instance Properties

    private let router: Router
    private let repository: FeedbackRepository

    // MARK: - Init Methods

    required init(router: CreateFeedbackRouter) {
        self.router = router
        repository = FeedbackRepository()
    }

    func dismisViewController() {
        router.dismissVC(navigationType: .stack, animated: false, completion: nil)
    }

    func showFileAttachment() {
        router.presentVC(CreateFeedbackRouteType.showFileAttachmentView(), navigationType: .stack, animated: false, completion: nil)
    }

    func showThankYou() {
        router.presentVC(CreateFeedbackRouteType.showThankYouView(), navigationType: .stack, animated: false, completion: nil)
    }

    func showErrorViewWith(errorMessage: ErrorMessageAndTitle) {
        router.presentVC(CreateFeedbackRouteType.showErrorView(data: errorMessage), navigationType: .stack, animated: false, completion: nil)
    }

    func submitFeedbackWith(feedback: Feedback, completion: @escaping (FeedbackSubmitResult) -> Void) {
        repository.submitFeedback(feedback) { result in
            completion(result)
        }
    }
}
