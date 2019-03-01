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
    case forgotPasswordError
    case forgotPasswordSuccess
    case cancelRSVP
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        contentView.layer.applySketchShadow(alpha: 0.22, y: 15, blur: 12)
        contentView.layer.applySketchShadow(alpha: 0.3, y: 19, blur: 38)
        closeButton.setTitle(GeneralStrings.dismissAction, for: .normal)

        switch alertType {
            // to do get real labels
            case .forgotPasswordError:
                alertTitleLabel.text = "Sorry something went wrong"
                alertMessageLabel.text = "We couldn't reset your password, try again later."
            // to do should we have a try again button as the action button
            case .forgotPasswordSuccess:
                alertTitleLabel.text = "Success"
                alertMessageLabel.text = "An email was sent your way."
            case .cancelRSVP:
                alertTitleLabel.text = ClassStrings.sorryYouCantMakeIt
                alertMessageLabel.text = ClassStrings.requiredClassMessage
                actionButton.setTitle(GeneralStrings.continueAction, for: .normal)
            case .systemError:
                alertTitleLabel.text = ErrorStrings.systemError
                alertMessageLabel.text = ErrorStrings.errorMessage
                actionButton.setTitle(ErrorStrings.support, for: .normal)
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
