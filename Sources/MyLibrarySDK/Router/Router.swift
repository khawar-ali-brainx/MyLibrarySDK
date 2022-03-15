//
//  Router.swift
//  ZyTrack
//
//  Created by BrainX Technologies on 2/19/21.
//

import UIKit

protocol RouteType {}

enum NavigationType {
    case overlay
    case stack
    case root
}

protocol Router {
    var viewController: BaseViewController? { get set }

    // Methods for presenting view controller
    func presentVC(_ routeType: RouteType, navigationType: NavigationType, animated: Bool, completion: (() -> Void)?)

    // Methods for pushing view controller
    func dismissVC(navigationType: NavigationType, animated: Bool, completion: (() -> Void)?)
}

extension Router {
    func presentVC(_: RouteType, navigationType _: NavigationType, animated _: Bool, completion _: (() -> Void)?) {}

    func dismissVC(navigationType: NavigationType, animated: Bool, completion: (() -> Void)?) {
        switch navigationType {
        case .overlay:
            viewController?.dismiss(animated: animated, completion: completion)
        case .stack:
            viewController?.navigationController?.popViewController(animated: animated)
        case .root:
            break
        }
    }
}
