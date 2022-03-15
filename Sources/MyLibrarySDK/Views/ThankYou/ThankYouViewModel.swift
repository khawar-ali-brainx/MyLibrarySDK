//
//  ThankYouViewModel.swift
//
//
//  Created by BrainX 3096 on 26/02/2022.
//

import Foundation

class ThankYouViewModel {
    // MARK: - Instance Properties

    private let router: Router
    private let repository: FeedbackRepository

    // MARK: - Init Methods

    required init(router: ThankYouRouter) {
        self.router = router
        repository = FeedbackRepository()
    }

    func dismisViewController() {
        router.dismissVC(navigationType: .stack, animated: false, completion: nil)
    }

    func submitFeedbackWith(feedback: Feedback, completion: @escaping (FeedbackSubmitResult) -> Void) {
        repository.submitFeedback(feedback) { result in
            completion(result)
        }
    }
}
