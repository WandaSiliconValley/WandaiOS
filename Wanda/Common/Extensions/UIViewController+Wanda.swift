//
//  UIViewController+Wanda.swift
//  Wanda
//
//  Created by Courtney & Matt on 4/4/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentErrorAlert(for type: WandaAlertType) {
        guard let selfAsDelegate = self as? WandaAlertViewDelegate, let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(type, delegate: selfAsDelegate) else {
            assertionFailure("Could not instantiate WandaAlertViewController.")
            return
        }
        self.present(wandaAlertViewController, animated: true, completion: nil)
    }
    
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        if var viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            viewControllers = viewControllers.reversed()
            for currentViewController in viewControllers {
                if currentViewController .isKind(of: toControllerType) {
                    self.navigationController?.popToViewController(currentViewController, animated: true)
                    break
                }
            }
        }
    }
}
