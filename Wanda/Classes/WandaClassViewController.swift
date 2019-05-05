//
//  WandaClassViewController.swift
//  Wanda
//
//  Created by Bell, Courtney on 3/6/18.
//  Copyright © 2018 Bell, Courtney. All rights reserved.
//

import UIKit
import MessageUI
import EventKitUI

private enum ReservationActionState {
    case cancelRSVP
    case discardRSVP
    case getWandaClass
    case retryCancelRSVP
    case retryDiscardRSVP
    case retryGetWandaClass
}

private enum ReservationState {
    case makeRSVP
    case changeRSVP
    case updateRSVP
}

class WandaClassViewController: UIViewController, WandaAlertViewDelegate, MFMailComposeViewControllerDelegate, EKEventEditViewDelegate {
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var cancelRSVPButton: UIButton!
    @IBOutlet private weak var changeRSVPButton: UIButton!
    @IBOutlet private weak var changeRSVPSpinner: UIActivityIndicatorView!
    @IBOutlet private weak var changeRSVPView: UIView!
    @IBOutlet private weak var childCareView: UIView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var dateTimeToContentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dateTimeToReservedViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var locationNameLabel: UILabel!
    @IBOutlet private weak var makeRSVPSpinner: UIActivityIndicatorView!
    @IBOutlet private weak var numberOfChildrenLabel: UILabel!
    @IBOutlet private weak var reservedHeader: UIView!
    @IBOutlet private weak var reservedHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sendRSVPButton: UIButton!
    @IBOutlet private weak var subtractbutton: UIButton!
    @IBOutlet private weak var timeLabel: UILabel!
    var classType: ClassType?
    var wandaClass: WandaClass?
    
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
    let overlayView = UIView(frame: UIScreen.main.bounds)
    
    static let storyboardIdentifier = String(describing: WandaClassViewController.self)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Currently users should only see this screen for the next class.
        guard let wandaClass = wandaClass else {
            return
        }
        
        configureNavigationBar()
        
        if wandaClass.isReserved {
            getReservedWandaClass {
                self.isReserved = wandaClass.isReserved
                self.configureView()
                self.configureMenu()
            }
        } else {
            isReserved = wandaClass.isReserved
            configureView()
            configureMenu()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(menuView?.hideMenu))
        self.view.addGestureRecognizer(tap)
    }
    
    private func configureView() {
        toggleSubtractChildButton()
        configureReservationView()
    }
    
    // MARK: IBActions
    
    @IBAction func didTapAddChildButton() {
        guard let numberOfChildrenString = numberOfChildrenLabel.text, var numberOfChildren = Int(numberOfChildrenString), let wandaClass = wandaClass else {
            return
        }
        numberOfChildren += 1
        numberOfChildrenLabel.text = String(numberOfChildren)
        unsavedChanges = numberOfChildren != wandaClass.childCareNumber
        toggleSubtractChildButton()
    }
    
    @IBAction func didTapSubtractChildButton() {
        guard let numberOfChildrenString = numberOfChildrenLabel.text, var numberOfChildren = Int(numberOfChildrenString), let wandaClass = wandaClass else {
            return
        }
        
        if numberOfChildren > 0 {
            numberOfChildren -= 1
            numberOfChildrenLabel.text = String(numberOfChildren)
        }
        toggleSubtractChildButton()
        
        unsavedChanges = numberOfChildren != wandaClass.childCareNumber
    }
    
    @IBAction func didTapCancelRSVPButton() {
//        guard let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(.cancelRSVP, delegate: self) else {
//            assertionFailure("Could not load the WandaAlertViewController.")
//            return
//        }
        
        reservationActionState = .cancelRSVP
        self.presentErrorAlert(for: .cancelRSVP)
   //     self.present(wandaAlertViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapSendRSVPButton() {
        switch reservationState {
            case .changeRSVP:
                // rename these cases ^ cus this is really update rsvp?
                logAnalytic(tag: WandaAnalytics.classDetailUpdateRSVPButtonTapped)
                if overlayView.superview != nil {
                    overlayView.removeFromSuperview()
                }
                
                toggleSubtractChildButton()
                addButton.imageView?.tintColor = WandaColors.darkPurple
                
                // to do this doesn't really slide
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                        self.reservedHeader.isHidden = true
                        self.dateTimeToContentViewTopConstraint.priority = .defaultHigh
                        self.dateTimeToReservedViewTopConstraint.priority = .defaultLow
                        self.childCareView.isUserInteractionEnabled = true
                        self.changeRSVPButton.setTitle(ClassStrings.updateRSVP, for: .normal)
                    })
                }
                
                // user hasn't made any changes yet
                unsavedChanges = false
                reservationState = .updateRSVP
            case .makeRSVP:
                logAnalytic(tag: WandaAnalytics.classDetailReserveSpotTapped)
                reserveWandaClass()
            case .updateRSVP:
                logAnalytic(tag: WandaAnalytics.classDetailUpdateRSVPButtonTapped)
                reserveWandaClass()
        }
    }
    
    // MARK: Private
    
    @objc
    private func didTapContactWanda() {
        guard let wandaClass = wandaClass, let contactUsViewController = ViewControllerFactory.makeContactUsViewController(for: .wandaClass) else {
            self.presentErrorAlert(for: .contactUsError)
            return
        }
        
        logAnalytic(tag: WandaAnalytics.classDetailMenuContatctWandaTapped)
        contactUsViewController.mailComposeDelegate = self
        contactUsViewController.setSubject("\(wandaClass.details.topic)")
        contactUsViewController.setMessageBody("Class Name: \n\(wandaClass.details.topic) \n\nTime: \n\(wandaClass.details.date) \n\(wandaClass.details.time) \n\nLocation: \n\(wandaClass.details.address)\n\(wandaClass.details.street), \(wandaClass.details.city)", isHTML: false)
        
        if let menuView = menuView {
            menuView.toggleMenu()
        }
        
        self.present(contactUsViewController, animated: true, completion: nil)
    }
    
    @objc
    private func didTapOverflowMenu() {
        logAnalytic(tag: WandaAnalytics.classDetailMenuButtonTapped)
        if let menuView = menuView {
            menuView.toggleMenu()
        }
    }
    
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        if unsavedChanges {
//            guard let wandaAlertViewController = ViewControllerFactory.makeWandaAlertController(.unsavedChanges, delegate: self) else {
//                assertionFailure("Could not load the WandaAlertViewController.")
//                return
//            }
            reservationActionState = .discardRSVP
            self.presentErrorAlert(for: .unsavedChanges)
         //   self.present(wandaAlertViewController, animated: true, completion: nil)
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapAddToCalendar() {
        guard let wandaClass = wandaClass else {
            // to do should we pop up an error here?
            return
        }
        
        logAnalytic(tag: WandaAnalytics.classDetailMenuAddEventTapped)
        
        let eventTimes = wandaClass.details.time.components(separatedBy: " - ")
        let startTime = DateFormatter.timeDateFormatter.date(from: eventTimes[0])
        let endTime = DateFormatter.timeDateFormatter.date(from: eventTimes[1])
        
        // to do getting there - still need to add the time component to the start/end date
        
        DispatchQueue.main.async {
            let eventStore = EKEventStore()
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if (granted) && (error == nil) {
                    if let menuView = self.menuView {
                        menuView.toggleMenu()
                    }
                    
                    let event = EKEvent(eventStore: eventStore)
                    event.title = wandaClass.details.topic
                    let eventDate = DateFormatter.simpleDateFormatter.date(from: wandaClass.details.date)
                    event.startDate = eventDate?.addingTimeInterval(TimeInterval())
                    event.endDate = eventDate
                    event.location = wandaClass.details.address
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    
                    let controller = EKEventEditViewController()
                    controller.event = event
                    controller.eventStore = eventStore
                    controller.editViewDelegate = self
                    controller.setNeedsStatusBarAppearanceUpdate()
                    self.present(controller, animated: true)
                }
            })
        }
    }
    
    private func getReservedWandaClass(completion: @escaping() -> (Void)) {
        guard let wandaClass = wandaClass, let motherId = dataManager.wandaMother?.motherId else {
            return
        }
        
        dataManager.getReservedWandaClass(classId: wandaClass.details.classId, motherId: motherId) { success, reservedClass, error in
            guard success, let reservedClass = reservedClass else {
                if let error = error {
                    // to do retry twice then contact support
                    self.reservationActionState = .retryGetWandaClass
                    switch error {
                        case .networkError:
                            self.presentErrorAlert(for: .networkError)
                        case .unknown:
                            self.presentErrorAlert(for: .systemError)
                    }
                }
                
                completion()
                return
            }
            
            wandaClass.childCareNumber = reservedClass.childcareNumber
            completion()
        }
    }
    
    private func configureReservationView() {
        guard let wandaClass = wandaClass, let classType = classType else {
            return
        }
        
        title = wandaClass.details.topic
        timeLabel.text = wandaClass.details.time
        locationNameLabel.text = wandaClass.details.address
        
        if let eventDate = DateFormatter.simpleDateFormatter.date(from: wandaClass.details.date) {
            dateLabel.text = DateFormatter.fullDayMonthFormatter.string(from: eventDate)
        }
        
        // to do fix this
        // to do log tap on address & make address open google maps
        var addressLabelText = ""
        if !wandaClass.details.unit.isEmpty {
            addressLabelText.append(wandaClass.details.unit + " ")
        }
        
        if !wandaClass.details.street.isEmpty {
            addressLabelText.append(wandaClass.details.street)
        }
        
        if !wandaClass.details.city.isEmpty {
            addressLabelText.append(", " + wandaClass.details.city)
        }
        
        addressLabel.isHidden = addressLabelText.isEmpty
        addressLabel.text = addressLabelText
        
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
        
        switch isReserved {
            case true:
                reservationState = .changeRSVP
                dateTimeToContentViewTopConstraint.priority = .defaultLow
                dateTimeToReservedViewTopConstraint.priority = .defaultHigh
                sendRSVPButton.backgroundColor = WandaColors.limeGreen
                overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                addButton.imageView?.tintColor = WandaColors.mediumGrey
                subtractbutton.imageView?.tintColor = WandaColors.mediumGrey
                self.view.addSubview(overlayView)
                self.view.bringSubviewToFront(changeRSVPView)
                self.view.bringSubviewToFront(reservedHeader)
            case false:
                addButton.imageView?.tintColor = WandaColors.darkPurple
                subtractbutton.imageView?.tintColor = WandaColors.darkPurple
                reservationState = .makeRSVP
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
        
        menuView?.addToCalendarButton.addTarget(self, action: #selector(didTapAddToCalendar), for: .touchUpInside)
        menuView?.contactUsButton.addTarget(self, action: #selector(didTapContactWanda), for: .touchUpInside)
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: WandaImages.backArrow, style: .plain, target: self, action: #selector(backButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: WandaImages.overflowIcon, style: .plain, target: self, action: #selector(didTapOverflowMenu))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont.wandaFontSemiBold(size: 20)]
    }
    
    private func toggleSubtractChildButton() {
        guard let numberOfChildrenText = numberOfChildrenLabel.text, let numberOfChildren = Int(numberOfChildrenText) else {
            return
        }
        
        if numberOfChildren > 0 {
            subtractbutton.imageView?.tintColor = WandaColors.darkPurple
            subtractbutton.isEnabled = true
        } else {
            subtractbutton.imageView?.tintColor = WandaColors.mediumGrey
            subtractbutton.isEnabled = false
        }
    }
    
    private func reserveWandaClass() {
        guard let motherId = dataManager.wandaMother?.motherId, let wandaClass = dataManager.nextClass, let numberOfChildrenText = numberOfChildrenLabel.text, let numberOfChildren = Int(numberOfChildrenText)  else {
            return
        }
        
        toggleCorrectSpinner()
        
        dataManager.reserveWandaClass(classId: wandaClass.details.classId, motherId: motherId, childcareNumber: numberOfChildren) { success, error in
            guard success, let reservationSuccessViewController = ViewControllerFactory.makeWandaSuccessController() else {
                if let error = error {
                    self.toggleCorrectSpinner()
                    switch error {
                        case .networkError:
                            self.presentErrorAlert(for: .networkError)
                        case .unknown:
                            self.presentErrorAlert(for: .systemError)
                    }
                }
                
                return
            }
            
            switch self.reservationState {
                case .updateRSVP:
                    reservationSuccessViewController.successType = .update
                default:
                    reservationSuccessViewController.successType = .reservation
            }
            
            self.toggleCorrectSpinner()
            self.navigationController?.pushViewController(reservationSuccessViewController, animated: true)
        }
    }
    
    private func toggleCorrectSpinner() {
        switch reservationState {
            case .makeRSVP:
                makeRSVPSpinner.toggleSpinner(for: sendRSVPButton, title: ClassStrings.sendRSVP)
            case .updateRSVP:
                changeRSVPSpinner.toggleSpinner(for: changeRSVPButton, title: ClassStrings.updateRSVP)
            default:
                return
        }
    }
    
    // MARK: WandaAlertViewDelegate
    
    func didTapActionButton() {
        guard let motherId = dataManager.wandaMother?.motherId, let wandaClass = dataManager.nextClass, let navigationController = navigationController else {
            return
        }
        
        switch reservationActionState {
            case .getWandaClass, .retryGetWandaClass:
                getReservedWandaClass{}
            case .cancelRSVP, .retryCancelRSVP:
                // to do where should the spinner be here since this is an alert?
                dataManager.cancelWandaClassReservation(classId: wandaClass.details.classId, motherId: motherId) { success, error in
                    guard success else {
                        if let error = error {
                            self.reservationActionState = .retryCancelRSVP
                            switch error {
                            case .networkError:
                                self.presentErrorAlert(for: .networkError)
                            case .unknown:
                                self.presentErrorAlert(for: .systemError)
                            }
                        }
                        
                        return
                    }
                    
                    self.dataManager.needsReload = true
                    navigationController.popViewController(animated: true)
                }
            case .discardRSVP, .retryDiscardRSVP:
                navigationController.popViewController(animated: true)
        }
    }
    
    // MARK: EKEventEditViewDelegate
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
