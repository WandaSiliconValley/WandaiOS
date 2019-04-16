//
//  WandaAlertViewController.swift
//  Wanda
//
//  Created by Bell, Courtney on 2/23/19.
//  Copyright © 2019 Bell, Courtney. All rights reserved.
//

import Foundation
import MessageUI
import UIKit

enum WandaAlertType {
    case addEventError
    case cantGetClasses
    case cancelRSVP
    case contactUsError
    case forgotPasswordSuccess
    case networkError
    case systemError
    case unsavedChanges
}


protocol WandaAlertViewDelegate: class {
    func didTapActionButton()
}

class WandaAlertViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var alertTitleLabel: UILabel!
    @IBOutlet private weak var alertMessageLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var actionButton: UIButton!

    var alertType: WandaAlertType = .systemError
    var delegate: WandaAlertViewDelegate?

    static let storyboardIdentifier = String(describing: WandaAlertViewController.self)

    // to do can we make it default before for retry to be the first action and support to be the second????
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        contentView.layer.applySketchShadow(alpha: 0.22, y: 15, blur: 12)
        contentView.layer.applySketchShadow(alpha: 0.3, y: 19, blur: 38)
        closeButton.setTitle(GeneralStrings.dismissAction, for: .normal)
        closeButton.isHidden = false

        switch alertType {
            case .addEventError:
                alertTitleLabel.text = ErrorStrings.systemError
                alertMessageLabel.text = "We can't seem to access your calendar. You may need to check your settings."
                closeButton.isHidden = true
                actionButton.setTitle(GeneralStrings.dismissAction, for: .normal)
            case .contactUsError:
                alertTitleLabel.text = ErrorStrings.systemError
                alertMessageLabel.text = "We can't seem to access your email. You may need to check your settings."
                closeButton.isHidden = true
                actionButton.setTitle(GeneralStrings.dismissAction, for: .normal)
            case .forgotPasswordSuccess:
                alertTitleLabel.text = GeneralStrings.success
                alertMessageLabel.text = LoginSignUpStrings.resetPasswordMessage
                closeButton.isHidden = true
                actionButton.setTitle(GeneralStrings.dismissAction, for: .normal)
            case .cantGetClasses:
                alertTitleLabel.text = ErrorStrings.systemError
                alertMessageLabel.text = ErrorStrings.classesErrorTryAgain
                actionButton.setTitle(GeneralStrings.retryAction, for: .normal)
            case .cancelRSVP:
                alertTitleLabel.text = ClassStrings.sorryYouCantMakeIt
                alertMessageLabel.text = ClassStrings.requiredClassMessage
                actionButton.setTitle(GeneralStrings.continueAction, for: .normal)
            case .networkError:
                alertTitleLabel.text = ErrorStrings.networkError
                alertMessageLabel.text = ErrorStrings.networkErrorMessage
                actionButton.setTitle(GeneralStrings.retryAction, for: .normal)
            case .systemError:
                alertTitleLabel.text = ErrorStrings.systemError
                alertMessageLabel.text = ErrorStrings.errorMessage
                actionButton.setTitle(GeneralStrings.retryAction, for: .normal)
            case .unsavedChanges:
                alertTitleLabel.isHidden = true
                alertMessageLabel.text = AlertStrings.oopsMessage
                closeButton.setTitle(AlertStrings.keepWorking, for: .normal)
                actionButton.setTitle(AlertStrings.discard, for: .normal)
        }
    }

    @IBAction func didTapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapActionButton() {
        guard let delegate = delegate else {
            return
        }

        self.dismiss(animated: true, completion: nil)
        delegate.didTapActionButton()
    }
}
