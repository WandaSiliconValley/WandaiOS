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
    case cancelRSVP
    case contactUsError
    case cohortMotherError
    case forgotPasswordSuccess
    case networkError
    case systemError
    case unsavedChanges
}


protocol WandaAlertViewDelegate: class {
    func didTapActionButton()
}

class WandaAlertViewController: UIViewController, MFMailComposeViewControllerDelegate, WandaAlertViewDelegate {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var alertTitleLabel: UILabel!
    @IBOutlet private weak var alertMessageLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var supportButton: UIButton!

    var alertType: WandaAlertType = .systemError
    var delegate: WandaAlertViewDelegate?
    
    static let storyboardIdentifier = String(describing: WandaAlertViewController.self)
    
    private var actionState: ActionState = .delegateAction
    private enum ActionState {
        case delegateAction
        case support
    }
    
    // to do can we make it default before for retry to be the first action and support to be the second????
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.layer.applySketchShadow(alpha: 0.22, y: 15, blur: 12)
        contentView.layer.applySketchShadow(alpha: 0.3, y: 19, blur: 38)
        closeButton.setTitle(GeneralStrings.dismissAction, for: .normal)
        closeButton.isHidden = false
        supportButton.isHidden = true
        
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
            case .cohortMotherError:
                alertTitleLabel.text = ErrorStrings.systemError
                alertMessageLabel.text = "We can't seem to load this profile. Please try again later."
                closeButton.isHidden = true
                actionButton.setTitle(GeneralStrings.dismissAction, for: .normal)
            case .forgotPasswordSuccess:
                alertTitleLabel.text = GeneralStrings.success
                alertMessageLabel.text = LoginSignUpStrings.resetPasswordMessage
                closeButton.isHidden = true
                actionButton.setTitle(GeneralStrings.dismissAction, for: .normal)
            case .cancelRSVP:
                alertTitleLabel.text = ClassStrings.sorryYouCantMakeIt
                alertMessageLabel.text = ClassStrings.requiredClassMessage
                actionButton.setTitle(GeneralStrings.continueAction, for: .normal)
            case .networkError:
                alertTitleLabel.text = ErrorStrings.networkError
                alertMessageLabel.text = ErrorStrings.networkErrorMessage
                actionButton.setTitle(GeneralStrings.tryAgainAction, for: .normal)
            case .systemError:
                alertTitleLabel.text = ErrorStrings.systemError
                alertMessageLabel.text = ErrorStrings.errorMessage
                actionButton.setTitle(GeneralStrings.tryAgainAction, for: .normal)
                supportButton.isHidden = false
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
        if actionState == .delegateAction {
            delegate.didTapActionButton()
        }
    }
    
    @IBAction func didTapSupportButton() {
        guard let contactUsViewController = ViewControllerFactory.makeContactUsViewController(for: .login) else {
            alertTitleLabel.text = ErrorStrings.systemError
            alertMessageLabel.text = "We can't seem to access your email. You may need to check your settings."
            closeButton.isHidden = true
            supportButton.isHidden = true
            actionState = .support
            actionButton.setTitle(GeneralStrings.dismissAction, for: .normal)
            return
        }
        
        actionState = .delegateAction
        contactUsViewController.mailComposeDelegate = self
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else {
                return
            }

            self.present(contactUsViewController, animated: true, completion: nil)
        }
    }
}
