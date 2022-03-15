//
//  LanguageSelectionViewModel.swift
//
//
//  Created by BrainX 3096 on 25/02/2022.
//

import Foundation

class LanguageSelectionViewModel {
    // MARK: - Instance Properties

    private let router: Router

    // MARK: - Init Methods

    required init(router: LanguageSelectionRouter) {
        self.router = router
    }

    // MARK: - Public Methods

    func showFeedbackTypeView(language: SupportedLanguages) {
        router.presentVC(LanguageSelectionRouteType.feedbackTypeView(data: language), navigationType: .stack, animated: false, completion: nil)
    }
}
