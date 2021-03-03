//
//  UIViewController+Wanda.swift
//  Wanda
//
//  Created by Courtney & Matt on 4/4/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import FirebaseAnalytics
import UIKit

extension UIViewController {
    func presentErrorAlert(for type: WandaAlertType) {
        DispatchQueue.main.async {
            guard let selfAsDelegate = self as? WandaAlertViewDelegate, let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(type, delegate: selfAsDelegate) else {
                return
            }

            self.present(wandaAlertViewController, animated: true) {
                wandaAlertViewController.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
            }
        }
    }
    
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        if var viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            viewControllers = viewControllers.reversed()
            for currentViewController in viewControllers {
                if currentViewController .isKind(of: toControllerType) {
                    self.dismiss(animated: false)
                    self.navigationController?.popToViewController(currentViewController, animated: true)
                    break
                }
            }
        }
    }
    
    // to do make this strict to the analytics tag strings - enum?
    func logAnalytic(tag: String) {
        Analytics.logEvent(tag, parameters: nil)
    }
    
    @objc
    private func dismissAlert() {
        dismiss(animated: true, completion: nil)
    }
}
