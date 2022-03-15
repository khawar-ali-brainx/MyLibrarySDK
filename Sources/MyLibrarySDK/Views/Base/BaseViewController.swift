//
//  BaseViewController.swift
//
//
//  Created by BrainX 3096 on 25/02/2022.
//

import UIKit

class BaseViewController: UIViewController {
    // MARK: - Override methods

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
        }
    }

    // MARK: - Public methods

    func showAlertView(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: LocalizeKey.ok.string.uppercased(), style: UIAlertAction.Style.default) { (_: UIAlertAction) -> Void in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
