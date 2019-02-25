//
//  ReservationViewController.swift
//  Wanda
//
//  Created by Bell, Courtney on 3/6/18.
//  Copyright © 2018 Bell, Courtney. All rights reserved.
//

import UIKit

// to do make reusable button

private enum ReservationActionState {
    case cancelRSVP
    case discardRSVP
}

class ReservationViewController: UIViewController, WandaAlertViewDelegate {
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var changeRSVPButton: UIButton!
    @IBOutlet private weak var changeRSVPView: UIView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var dateTimeToContentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dateTimeToReservedViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var locationNameLabel: UILabel!
    @IBOutlet private weak var numberOfChildrenLabel: UILabel!
    @IBOutlet private weak var reservedHeader: UIView!
    @IBOutlet private weak var reservedHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var RSVPLabel: UILabel!
    @IBOutlet private weak var sendRSVPButton: UIButton!
    @IBOutlet private weak var timeLabel: UILabel!

    private var dataManager = WandaDataManager.shared
    private var isReserved = false
    private var menuView: WandaClassMenu?
    private var reservationActionState: ReservationActionState = .discardRSVP
    private var unsavedChanges = false {
        didSet {
            changeRSVPButton.backgroundColor = unsavedChanges ? WandaColors.limeGreen : WandaColors.limeGreen.withAlphaComponent(0.5)
            changeRSVPButton.isEnabled = unsavedChanges
        }
    }
    private var wandaClass: WandaClassInfo?

    static let storyboardIdentifier = String(describing: ReservationViewController.self)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Currently users should only see this screen for the next class.
        guard let wandaClass = dataManager.nextClass else {
            return
        }

        self.wandaClass = wandaClass
        isReserved = wandaClass.isReserved

        configureNavigationBar()
        configureMenu()
        configureReservationView()
    }

    // MARK: Private

    private func configureReservationView() {
        guard let wandaClass = wandaClass else {
            return
        }

        title = wandaClass.topic
        timeLabel.text = wandaClass.time
        locationNameLabel.text = wandaClass.address

        reservedHeader.isHidden = !isReserved
        changeRSVPView.isHidden = !isReserved
        sendRSVPButton.isHidden = isReserved

        switch isReserved {
            case true:
                dateTimeToContentViewTopConstraint.priority = .defaultLow
                dateTimeToReservedViewTopConstraint.priority = .defaultHigh
                sendRSVPButton.backgroundColor = WandaColors.limeGreen
                RSVPLabel.text = ClassStrings.iCantMakeIt
            case false:
                RSVPLabel.text = ClassStrings.reserveMySpot
                RSVPLabel.textColor = UIColor.white.withAlphaComponent(0.5)
                sendRSVPButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
        }
    }

    private func configureMenu() {
        menuView = WandaClassMenu(frame: CGRect(x: 0, y: 0, width: 250, height: 96))
        if let menuView = menuView {
            menuView.frame.origin.y = 0
            menuView.frame.origin.x = self.view.frame.width - menuView.frame.width

            self.view.addSubview(menuView)
        }
    }

    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: WandaImages.backArrow, style: .plain, target: self, action: #selector(backButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: WandaImages.overflowIcon, style: .plain, target: self, action: #selector(didTapOverflowMenu))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font: UIFont.wandaFontSemiBold(size: 20)]
    }

    @objc
    private func didTapOverflowMenu() {
        if let menuView = menuView {
            menuView.toggleMenu()
        }
    }

    @objc
    private func backButtonPressed(_ sender: UIButton) {
        reservationActionState = .discardRSVP
        if unsavedChanges {
            guard let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(.unsavedChanges, delegate: self) else {
                assertionFailure("Could not load the WandaAlertViewController.")
                return
            }
            self.present(wandaAlertViewController, animated: true, completion: nil)
        }
        _ = navigationController?.popViewController(animated: true)
    }

    // MARK: IBActions

    @IBAction func didTapAddChildButton() {
        guard let numberOfChildrenString = numberOfChildrenLabel.text, var numberOfChildren = Int(numberOfChildrenString), let wandaClass = wandaClass else {
            return
        }
        numberOfChildren += 1
        numberOfChildrenLabel.text = String(numberOfChildren)
        unsavedChanges = numberOfChildren != wandaClass.childCareNumber
    }

    @IBAction func didTapSubtractChildButton() {
        guard let numberOfChildrenString = numberOfChildrenLabel.text, var numberOfChildren = Int(numberOfChildrenString), let wandaClass = wandaClass else {
            return
        }

        if numberOfChildren > 0 {
            numberOfChildren -= 1
            numberOfChildrenLabel.text = String(numberOfChildren)
        }
        unsavedChanges = numberOfChildren != wandaClass.childCareNumber
    }

    @IBAction func didTapCancelRSVPButton() {
        reservationActionState = .cancelRSVP

        guard let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(.cancelRSVP, delegate: self) else {
            assertionFailure("Could not load the WandaAlertViewController.")
            return
        }

        self.present(wandaAlertViewController, animated: true, completion: nil)
    }

    @IBAction func didTapSendRSVPButton() {
        guard let motherId = dataManager.wandaMother?.motherId, let wandaClass = dataManager.nextClass, let numberOfChildrenText = numberOfChildrenLabel.text, let numberOfChildren = Int(numberOfChildrenText)  else {
            return
        }

        dataManager.reserveWandaClass(classId: wandaClass.classId, motherId: motherId, childcareNumber: numberOfChildren) { success in
            guard success, let reservationSuccessViewController = ViewControllerFactory.makeWandaSuccessController() else {
                if let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(.systemError, delegate: self) {
                    self.present(wandaAlertViewController, animated: true, completion: nil)
                }

                return
            }

            reservationSuccessViewController.successType = .reservation
            reservationSuccessViewController.dataManager = self.dataManager
            self.navigationController?.pushViewController(reservationSuccessViewController, animated: true)
        }
    }

    // MARK: WandaAlertViewDelegate

    func didTapActionButton() {
        guard let motherId = dataManager.wandaMother?.motherId, let wandaClass = dataManager.nextClass, let firebaseId = dataManager.wandaMother?.firebaseId, let navigationController = navigationController else {
            return
        }

        switch reservationActionState {
            case .cancelRSVP:
                dataManager.cancelWandaClassReservation(classId: wandaClass.classId, motherId: motherId) { success in
                    guard success else {
                        self.presentSystemAlert()
                        return
                    }

                    self.dataManager.getWandaMother(firebaseId: firebaseId) { success in
                        guard success else {
                            self.presentSystemAlert()
                            return
                        }
                        self.dataManager.loadClasses()
                        navigationController.popViewController(animated: true)
                    }
                }
            case .discardRSVP:
                navigationController.popViewController(animated: true)
        }
    }

    private func presentSystemAlert() {
        guard let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(.systemError, delegate: self) else {
            assertionFailure("Could not instantiate WandaAlertViewController.")
            return
        }

        self.present(wandaAlertViewController, animated: true, completion: nil)
    }
}
