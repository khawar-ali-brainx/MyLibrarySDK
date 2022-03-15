//
//  BasicUIViewModel.swift
//
//
//  Created by BrainX 3096 on 25/02/2022.
//

import Foundation

class BasicUIViewModel {
    // MARK: - Instance Properties

    private let router: Router

    // MARK: - Init Methods

    required init(router: BasicUIRouter) {
        self.router = router
    }

    func dismisViewController() {
        router.dismissVC(navigationType: .stack, animated: true, completion: nil)
    }
}
