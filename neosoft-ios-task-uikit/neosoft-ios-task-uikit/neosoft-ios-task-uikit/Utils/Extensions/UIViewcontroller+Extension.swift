//
//  File.swift
//  neosoft-ios-task-uikit
//
//  Created by JustMac on 30/07/24.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, msg: String, _ completion : (() -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { _ in
            alertViewController.dismiss(animated: true, completion: nil)
            completion?()
        }
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
}
