//
//  ProfileViewController.swift
//  Wanda
//
//  Created by Courtney Bell on 10/7/20.
//  Copyright © 2020 Bell, Courtney. All rights reserved.
//

import FirebaseAuth
import Foundation
import MessageUI
import UIKit
import AlamofireImage

var firstView = true

class ProfileViewController: UIViewController, MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, CollapsibleTableViewHeaderDelegate, UIGestureRecognizerDelegate, WandaAlertViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bioTitle: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var languagesTitle: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var phoneNumberTitle: UILabel!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var cohortLabel: UILabel!
    
    let screenHeight = UIScreen.main.bounds.height
    
    static let storyboardIdentifier = String(describing: ProfileViewController.self)
    private var menuView: WandaMenu?
    private var dataManager = WandaDataManager.shared
    private var tap: UITapGestureRecognizer!
    
    let bioPlaceholderText =  "'Here is your bio, let your cohort know a bit about you. If you have preferences for how to be contacted let other moms know here :)'"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tap = UITapGestureRecognizer(target: self, action: #selector(hideMenuIfPossible))
        self.tap.delegate = self
        self.scrollView.addGestureRecognizer(tap)
        scrollView.scrollsToTop = false
        
//        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 1000)
//        scrollView.delegate = self
//        scrollView.bounces = false
//        tableView.bounces = false
//        tableView.isScrollEnabled = false

        
        tableView.dataSource = self
        tableView.delegate = self
        let cohortTableViewCellNib = UINib(nibName: CohortTableViewCell.nibName(), bundle: nibBundle)
        tableView.register(cohortTableViewCellNib, forCellReuseIdentifier: CohortTableViewCell.nibName())
        let classesHeaderViewNib = UINib(nibName: CollapsibleTableViewHeader.nibName(), bundle: nibBundle)
        tableView.register(classesHeaderViewNib, forHeaderFooterViewReuseIdentifier: CollapsibleTableViewHeader.nibName())
        
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 56.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.scrollsToTop = true
        configureMenu()
    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.bounds.intersects(self.view.frame) == true {
//                 //the UIView is within frame, use the UIScrollView's scrolling.
//
//                    if tableView.contentOffset.y == 0 {
//                        //tableViews content is at the top of the tableView.
//
//                    tableView.isUserInteractionEnabled = false
//                   tableView.resignFirstResponder()
//                    print("using scrollView scroll")
//
//                    } else {

                        //UIView is in frame, but the tableView still has more content to scroll before resigning its scrolling over to ScrollView.
//
//                        tableView.isUserInteractionEnabled = true
//                        scrollView.resignFirstResponder()
//                        print("using tableView scroll")
//                    }
//
//                } else {
//
//                    //UIView is not in frame. Use tableViews scroll.
//
//                    tableView.isUserInteractionEnabled = true
//                   scrollView.resignFirstResponder()
//                    print("using tableView scroll")
//
//                }
//    }
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let yOffset = scrollView.contentOffset.y
//
//        if scrollView == self.scrollView {
//            if yOffset >= 1000 - screenHeight {
//                scrollView.isScrollEnabled = false
//                tableView.isScrollEnabled = true
//            }
//        }
//
//        if scrollView == self.tableView {
//            if yOffset <= 0 {
//                self.scrollView.isScrollEnabled = true
//                self.tableView.isScrollEnabled = false
//            }
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideMenuIfPossible()
    }
    
    
//    override func viewWillLayoutSubviews(){
//        super.viewWillLayoutSubviews()
//
//        scrollView.contentSize = CGSize(width: 375, height: 1000)
//    }
//
//    override func viewDidLayoutSubviews() {
//        scrollView.contentSize = contentView.frame.size
////        scrollView.contentSize.height = contentView.frame.size.height + 50
////        tableView.frame.size = tableView.contentSize
////        tableView.setNeedsLayout()
////        tableView.sizeToFit()
////        tableView.layoutSubviews()
//    }
    
    @objc
    func hideMenuIfPossible() {
        guard menuView?.contentView.isHidden == false else {
            return
        }
        
        menuView?.toggleMenu()
    }
    
//    override func didmove
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let menuView = menuView else {
            return false
        }
        
        if touch.view?.isDescendant(of: self.tableView) == true {
            return false
        }

        return !menuView.isHidden
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationBar()
        if dataManager.profilePictureNeedsReload {
            clearImageFromCache()
        } else {
            getMotherPhoto()
        }

        configureMotherInfo()

        adjustUITextViewHeight()
    }

    func adjustUITextViewHeight()
    {
        bioLabel.sizeToFit()
        languagesLabel.sizeToFit()
    }

    func didTapActionButton() {
        return
      }
    
    func getMotherPhoto() {
        let motherName = dataManager.wandaMother?.name ?? "?"
        showInitialView(name: motherName, initialImage: profileImage)
        if let motherId = dataManager.wandaMother?.motherId {
            let downloadURL = URL(string: "https://wanda-photos-bucket.s3-us-west-2.amazonaws.com/\(motherId)")!
            let urlRequest = URLRequest(url: downloadURL)
            profileImage.af.setImage(withURLRequest: urlRequest)
        }
    }
    
    func clearImageFromCache() {
        if let motherId = dataManager.wandaMother?.motherId {
            let downloadURL = URL(string: "https://wanda-photos-bucket.s3-us-west-2.amazonaws.com/\(motherId)")!
            let urlRequest = URLRequest(url: downloadURL)
            let imageDownloader = UIImageView.af.sharedImageDownloader
            _ = imageDownloader.imageCache?.removeImage(for: urlRequest, withIdentifier: nil)
            imageDownloader.session.sessionConfiguration.urlCache?.removeCachedResponse(for: urlRequest)
            
            getMotherPhoto()
        }
    }
    
    func configureMotherInfo() {
        guard let mother = dataManager.wandaMother else {
            logAnalytic(tag: WandaAnalytics.profileLoadError)
            return
        }
        
        cohortLabel.text = "I'm in Cohort " + String(mother.cohortId)
        introLabel.text = "Hi, I'm " + mother.name
        
        if mother.bio?.isEmpty == false, let bio = mother.bio {
            bioLabel.text = bio
        } else {
            bioLabel.text = bioPlaceholderText
        }
        
        if mother.shareContactEmail == true, let email = mother.contactEmail, !email.isEmpty {
            emailTitle.isHidden = false
            emailButton.isHidden = false
            emailButton.setTitle(email, for: .normal)
        } else {
            emailTitle.isHidden = true
            emailButton.isHidden = true
        }
        
        if mother.sharePhoneNumber == true, let phoneNumber = mother.phoneNumber, !phoneNumber.isEmpty {
            phoneNumberTitle.isHidden = false
            phoneNumberButton.isHidden = false
            phoneNumberButton.setTitle(phoneNumber, for: .normal)
        } else {
            phoneNumberTitle.isHidden = true
            phoneNumberButton.isHidden = true
        }
        
        
        if mother.languages.isEmpty == false && mother.languages[0] != "" {
            languagesTitle.isHidden = false
            languagesLabel.isHidden = false
            languagesLabel.text = configureLanguagesText(mother.languages)
        } else {
            languagesTitle.isHidden = true
            languagesLabel.isHidden = true
        }
        
    }
    
    func configureLanguagesText(_ languages: [String]) -> String {
        var languagesString = ""
        for language in languages {
            if languages.last == language {
                languagesString += language
            } else {
                languagesString += language + ", "
            }
        }
        
        return languagesString
    }
    
    
    func showInitialView(name: String, initialImage: UIImageView) {
        let initialLabel = UILabel()
        initialLabel.frame.size = CGSize(width: 100.0, height: 100.0)
        initialLabel.textColor = UIColor.white
        initialLabel.text = String(name.first?.uppercased() ?? "?")
        initialLabel.font = UIFont.wandaFontRegular(size: 60)
        initialLabel.textAlignment = NSTextAlignment.center
        initialLabel.backgroundColor = WandaColors.mediumPurple

        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(initialLabel.bounds.size, false, scale)
        initialLabel.layer.render(in: UIGraphicsGetCurrentContext()!)
        initialImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        initialImage.circularBorder()
    }
    
    private func configureNavigationBar() {
        navigationController?.view.backgroundColor = WandaColors.lightPurple
        if let navigationBar = self.navigationController?.navigationBar,
            let navigationItem = self.tabBarController?.navigationItem {
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
            titleLabel.text = "Profile"
            titleLabel.textColor = UIColor.white
            titleLabel.font = UIFont.wandaFontSemiBold(size: 20)
            navigationItem.titleView = titleLabel
            navigationItem.hidesBackButton = true

            navigationItem.rightBarButtonItem = UIBarButtonItem(image: WandaImages.overflowIcon, style: .plain, target: self, action: #selector(didTapOverflowMenu))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            navigationBar.barTintColor = WandaColors.lightPurple
            navigationBar.isTranslucent = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataManager.cohortSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataManager.cohortSections[section].collapsed ? 0 : dataManager.cohortSections[section].mothers.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CollapsibleTableViewHeader.nibName()) as? CollapsibleTableViewHeader else {
            return UIView()
        }
        
        headerView.section = section
        headerView.delegate = self
        
        if dataManager.cohortSections[section].collapsed {
            headerView.arrowImage.image = WandaImages.downArrow
        } else {
            headerView.setCollapsed(collapsed: dataManager.cohortSections[section].collapsed)
        }

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cohortCell = tableView.dequeueReusableCell(withIdentifier: CohortTableViewCell.nibName(), for: indexPath) as? CohortTableViewCell else {
            logAnalytic(tag: WandaAnalytics.profileCohortListLoadError)
            return UITableViewCell()
        }
        let cohortMother = dataManager.cohortSections[indexPath.section].mothers[indexPath.row]
        let userName = cohortMother.name
        cohortCell.nameLabel.text = userName
        showInitialView(name: userName, initialImage: cohortCell.profilePicture)
        let downloadURL = URL(string: "https://wanda-photos-bucket.s3-us-west-2.amazonaws.com/\(cohortMother.motherId)")!
        cohortCell.profilePicture.af.setImage(withURL: downloadURL)
        return cohortCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataManager.cohortSections[(indexPath as NSIndexPath).section].collapsed ? 0 : UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cohortSection = dataManager.cohortSections[indexPath.section]
        let cohortMother = cohortSection.mothers[indexPath.row]

        guard let cohortMotherProfileViewController = ViewControllerFactory.makeCohortMotherProfileViewController(cohortMother: cohortMother, cohortId: cohortSection.cohortId) else {
                logAnalytic(tag: WandaAnalytics.profileCohortMotherClickedError)
                hideMenuIfPossible()
                tableView.deselectRow(at: indexPath, animated: true)
                self.presentErrorAlert(for: .cohortMotherError)

                return
        }
        
        hideMenuIfPossible()
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(cohortMotherProfileViewController, animated: true)
        
    }

    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !dataManager.cohortSections[section].collapsed

        // Toggle collapse
        dataManager.cohortSections[section].collapsed = collapsed

        // Reload the whole section
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
    @objc
    private func didTapOverflowMenu() {
        if let menuView = menuView {
            menuView.toggleMenu()
        }
    }
    
    
    private func configureMenu() {
        menuView = WandaMenu(frame: CGRect(x: 0, y: 0, width: 250, height: 96))
        if let menuView = menuView {
            menuView.frame.origin.y = 0
            menuView.frame.origin.x = self.view.frame.width - menuView.frame.width
            
            self.view.addSubview(menuView)
            self.view.bringSubview(toFront: menuView)
        }
        
        menuView?.logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        menuView?.contactUsButton.addTarget(self, action: #selector(didTapContactWanda), for: .touchUpInside)
    }
    
    @objc
    func didTapLogoutButton() {
        do {
            try Auth.auth().signOut()
        } catch {
            // We are currently failing silently and sending the user back to the LoginViewController.
            self.logAnalytic(tag: WandaAnalytics.profileOverflowMenuLogoutError)
            print("Couldn't sign user out. Returning back to Login.")
        }
//        popBack(toControllerType: LoginViewController.self)
        
        let didPopBack = popBack(toControllerType: LoginViewController.self)
        
        if didPopBack == false {
            guard let loginViewController = ViewControllerFactory.makeLoginViewController() else {
                assertionFailure("Could not load the LoginViewController.")
                return
            }
            loginViewController.fromSignUpFlow = true

    //        logAnalytic(tag: WandaAnalytics.loginSignUpButtonTapped)
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
    
    @objc
    private func didTapContactWanda() {
        guard let contactUsViewController = ViewControllerFactory.makeContactUsViewController(for: .profileHelp) else {
            self.logAnalytic(tag: WandaAnalytics.profileOverflowMenuContactError)
            self.presentErrorAlert(for: .contactUsError)
            return
        }
        
        contactUsViewController.mailComposeDelegate = self
        
        if let menuView = menuView {
            menuView.toggleMenu()
        }
        
        self.present(contactUsViewController, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapEditProfile() {
        hideMenuIfPossible()

        DispatchQueue.main.async {
            guard let editProfileViewController = ViewControllerFactory.makeEditProfileViewController() else {
                self.logAnalytic(tag: WandaAnalytics.profileEditProfileClickedError)
                assertionFailure("Could not instantiate EditProfileViewController.")
                return
            }
            self.navigationController?.pushViewController(editProfileViewController, animated: true)
        }
    }
    
    @IBAction func didTapEmail(_ sender: UIButton) {
        guard let contactUsViewController = ViewControllerFactory.makeContactUsViewController(for: .profile, recipient: sender.titleLabel?.text ?? "") else {
            self.logAnalytic(tag: WandaAnalytics.profileEmailClickedError)
            self.presentErrorAlert(for: .contactUsError)
            return
        }

        contactUsViewController.mailComposeDelegate = self
        self.present(contactUsViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapPhoneNumber(_ sender: UIButton) {
        guard let phoneNumber = sender.titleLabel?.text, let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) else {
            self.logAnalytic(tag: WandaAnalytics.profilePhoneClickedError)
            self.presentErrorAlert(for: .contactUsError)
            return
        }
        
        UIApplication.shared.open(url)
    }

}
