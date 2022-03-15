//
//  FloatingButtonViewModel.swift
//
//
//  Created by BrainX 3096 on 25/02/2022.
//

import Foundation

class FloatingButtonViewModel {
    // MARK: - Instance Properties

    private let router: Router

    // MARK: - Init Methods

    required init(router: FloatingButtonRouter) {
        self.router = router
    }

    // MARK: - Public Methods

    func showLanguageSelectionView() {
        router.presentVC(FloatingButtonRouteType.languageSelectionView(), navigationType: .stack, animated: true, completion: nil)
    }
}
