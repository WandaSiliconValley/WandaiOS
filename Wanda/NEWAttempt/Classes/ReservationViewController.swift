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

private enum ReservationState {
    case makeRSVP
    case changeRSVP
    case updateRSVP
}

class ReservationViewController: UIViewController, WandaAlertViewDelegate {
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var changeRSVPButton: UIButton!
    @IBOutlet private weak var changeRSVPView: UIView!
    @IBOutlet private weak var childCareView: UIView!
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

    var classType: ClassType?
    var wandaClass: WandaClassInfo?

    private var dataManager = WandaDataManager.shared
    private var isReserved = false
    private var menuView: WandaClassMenu?
    private var reservationActionState: ReservationActionState = .cancelRSVP
    private var reservationState: ReservationState = .changeRSVP
    private var unsavedChanges = false {
        didSet {
            changeRSVPButton.backgroundColor = unsavedChanges ? WandaColors.limeGreen : WandaColors.limeGreen.withAlphaComponent(0.5)
            changeRSVPButton.isEnabled = unsavedChanges
        }
    }

    static let storyboardIdentifier = String(describing: ReservationViewController.self)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Currently users should only see this screen for the next class.
        guard let wandaClass = wandaClass else {
            return
        }

        isReserved = wandaClass.isReserved

        configureNavigationBar()
        configureMenu()
        configureReservationView()
    }

    // MARK: Private

    private func configureReservationView() {
        guard let wandaClass = wandaClass, let classType = classType else {
            return
        }

        title = wandaClass.topic
        timeLabel.text = wandaClass.time
        locationNameLabel.text = wandaClass.address
        numberOfChildrenLabel.text = String(wandaClass.childCareNumber)

        switch classType {
            case .nextClass:
                configureNextClassView()
            case .upcomingClass:
                configureUpcomingClassView()
        }

    }

    private func configureUpcomingClassView() {
        sendRSVPButton.isHidden = true
        childCareView.isHidden = true
        changeRSVPView.isHidden = true
    }

    private func configureNextClassView() {
        reservedHeader.isHidden = !isReserved
        changeRSVPView.isHidden = !isReserved
        sendRSVPButton.isHidden = isReserved
        childCareView.isUserInteractionEnabled = !isReserved

        switch isReserved {
            case true:
                reservationState = .changeRSVP
                dateTimeToContentViewTopConstraint.priority = .defaultLow
                dateTimeToReservedViewTopConstraint.priority = .defaultHigh
                sendRSVPButton.backgroundColor = WandaColors.limeGreen
                RSVPLabel.text = ClassStrings.iCantMakeIt
            case false:
                reservationState = .makeRSVP
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


//    func showAndHideFilterMenu(category : Int) {
//        if showFilterMenu == false {
//            self.filterView.alpha = 0.0
//            self.filterView.isHidden = false
//            self.showFilterMenu = true
//
//            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
//                self.filterView.alpha = 1.0
//            }) { (isCompleted) in
//            }
//        } else{
//            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
//                self.filterView.alpha = 0.0
//            }) { (isCompleted) in
//                self.filterView.isHidden = true
//                self.self.showFilterMenu = false
//            }
//        }
//    }

    @IBAction func didTapSendRSVPButton() {
        switch reservationState {
            case .changeRSVP:
                childCareView.isUserInteractionEnabled = true
                changeRSVPButton.setTitle("UPDATE RSVP", for: .normal)
                // user hasn't made any changes yet
                unsavedChanges = false


                // to do this doesn't really slide
                UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                    self.reservedHeader.isHidden = true
                    self.dateTimeToContentViewTopConstraint.priority = .defaultHigh
                    self.dateTimeToReservedViewTopConstraint.priority = .defaultLow
                })

                reservationState = .updateRSVP
            case .makeRSVP, .updateRSVP:
                reserveWandaClass()
        }
    }

    private func reserveWandaClass() {
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
