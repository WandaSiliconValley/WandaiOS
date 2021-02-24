//
//  ProfileViewController.swift
//  Wanda
//
//  Created by Courtney Bell on 10/7/20.
//  Copyright © 2020 Bell, Courtney. All rights reserved.
//

import Foundation
import MessageUI
import UIKit

class ProfileViewController: UIViewController, MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, CollapsibleTableViewHeaderDelegate {
    @IBOutlet var tableView: UITableView!
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
    
    static let storyboardIdentifier = String(describing: ProfileViewController.self)
    private var menuView: WandaClassMenu?
    private var dataManager = WandaDataManager.shared
//    private var cohortSections: [CohortSection]?
    private var firstView = true

    
//    struct CohortSection {
//      var mothers: [WandaCohortMother]
//      var collapsed: Bool
//
//      init(mothers: [WandaCohortMother], collapsed: Bool = false) {
//        self.mothers = mothers
//        self.collapsed = collapsed
//      }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 56.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        
//        dataManager.getCohort(cohortId: 12) { success, cohort, error in
//            guard let cohort = cohort else {
////                to do error handle
//                return
//            }
//
////            self.motherCohort = cohort
//
//            self.cohortSections = [CohortSection(mothers: cohort.mothers)]
//
//            print("HM")
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationBar()
        let motherName = dataManager.wandaMother?.name ?? "?"
        showInitialView(name: motherName, initialImage: profileImage)
        configureMotherInfo()


        
        tableView.dataSource = self
        tableView.delegate = self
        let cohortTableViewCellNib = UINib(nibName: CohortTableViewCell.nibName(), bundle: nibBundle)
        tableView.register(cohortTableViewCellNib, forCellReuseIdentifier: CohortTableViewCell.nibName())
        let classesHeaderViewNib = UINib(nibName: CollapsibleTableViewHeader.nibName(), bundle: nibBundle)
        tableView.register(classesHeaderViewNib, forHeaderFooterViewReuseIdentifier: CollapsibleTableViewHeader.nibName())
    }
    
    func configureMotherInfo() {
        guard let mother = dataManager.wandaMother else {
            // TO DO handle error
            return
        }
        
        cohortLabel.text = "I'm in Cohort " + String(mother.cohortId)
        introLabel.text = "Hi, I'm " + mother.name
        
        if mother.bio?.isEmpty == false, let bio = mother.bio {
            bioLabel.text = bio
        }
        
        if mother.shareContactEmail == true, let email = mother.contactEmail {
            emailTitle.isHidden = false
            emailButton.isHidden = false
            emailButton.setTitle(email, for: .normal)
        } else {
            emailTitle.isHidden = true
            emailButton.isHidden = true
        }
        
        if mother.sharePhoneNumber == true, let phoneNumber = mother.phoneNumber {
            phoneNumberTitle.isHidden = false
            phoneNumberButton.isHidden = false
            phoneNumberButton.setTitle(phoneNumber, for: .normal)
        } else {
            phoneNumberTitle.isHidden = true
            phoneNumberButton.isHidden = true
        }
        
        if mother.languages.isEmpty == false {
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
//        guard let sections = cohortSections else {
//            return 0
//        }
        
        return dataManager.cohortSections[section].collapsed ? 0 : dataManager.cohortSections[section].mothers.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CollapsibleTableViewHeader.nibName()) as? CollapsibleTableViewHeader else {
            return UIView()
        }
        if firstView != true {
            print("IS IT")
            headerView.setCollapsed(collapsed: dataManager.cohortSections[section].collapsed)
        }
        firstView = false
        headerView.section = section
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cohortCell = tableView.dequeueReusableCell(withIdentifier: CohortTableViewCell.nibName(), for: indexPath) as? CohortTableViewCell else {
            return UITableViewCell()
        }
        
        let userName = dataManager.cohortSections[indexPath.section].mothers[indexPath.row].name
        cohortCell.nameLabel.text = userName
        showInitialView(name: userName, initialImage: cohortCell.profilePicture)
        return cohortCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataManager.cohortSections[(indexPath as NSIndexPath).section].collapsed ? 0 : UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cohortSection = dataManager.cohortSections[indexPath.section]
        let cohortMother = cohortSection.mothers[indexPath.row]
        guard let cohortMotherProfileViewController = ViewControllerFactory.makeCohortMotherProfileViewController(cohortMother: cohortMother, cohortId: cohortSection.cohortId) else {
            return
        }
        
        self.navigationController?.pushViewController(cohortMotherProfileViewController, animated: true)
    }

    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !dataManager.cohortSections[section].collapsed

        // Toggle collapse
        dataManager.cohortSections[section].collapsed = collapsed
//        header.setCollapsed(collapsed: collapsed)

        // Reload the whole section
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
    //    TO DO - will need to add a new menu list for this - doesnt work at the moment
    @objc
    private func didTapOverflowMenu() {
        logAnalytic(tag: WandaAnalytics.classDetailMenuButtonTapped)
        if let menuView = menuView {
            menuView.toggleMenu()
        }
    }
    
    @IBAction func didTapEditProfile() {
        DispatchQueue.main.async {
            guard let editProfileViewController = ViewControllerFactory.makeEditProfileViewController() else {
                assertionFailure("Could not instantiate EditProfileViewController.")
                return
            }

            self.navigationController?.pushViewController(editProfileViewController, animated: true)
        }
    }
    
    @IBAction func didTapEmail(_ sender: UIButton) {
        guard let contactUsViewController = ViewControllerFactory.makeContactUsViewController(for: .profile, recipient: sender.titleLabel?.text ?? "") else {
//            to do - make a new error for this.
            self.presentErrorAlert(for: .contactUsError)
            return
        }

        contactUsViewController.mailComposeDelegate = self
        self.present(contactUsViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapPhoneNumber(_ sender: UIButton) {
        guard let phoneNumber = sender.titleLabel?.text, let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) else {
            self.presentErrorAlert(for: .contactUsError)
            return
        }
        
        UIApplication.shared.open(url)
    }

}
