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

class ProfileViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet var tableView: UITableView!
    
    static let storyboardIdentifier = String(describing: ProfileViewController.self)
    private var menuView: WandaClassMenu?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationController?.view.backgroundColor = WandaColors.lightPurple
        if let navigationBar = self.navigationController?.navigationBar,
            let navigationItem = self.tabBarController?.navigationItem {
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
            titleLabel.text = "       Profile"
            titleLabel.textColor = UIColor.white
            titleLabel.font = UIFont.wandaFontBold(size: 20)
            navigationItem.titleView = titleLabel
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: WandaImages.backArrow, style: .plain, target: self, action: #selector(backButtonPressed))
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: WandaImages.overflowIcon, style: .plain, target: self, action: #selector(didTapOverflowMenu))
            navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            navigationBar.barTintColor = WandaColors.lightPurple
            navigationBar.isTranslucent = false
        }
    }
    
    //    TO DO - will need to add a new menu list for this - doesnt work at the moment
    @objc
    private func didTapOverflowMenu() {
        logAnalytic(tag: WandaAnalytics.classDetailMenuButtonTapped)
        if let menuView = menuView {
            menuView.toggleMenu()
        }
    }
            
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
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
    
    struct Section {
      var name: String
      var items: [String]
      var collapsed: Bool
        
      init(name: String, items: [String], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
      }
    }
        
    var sections = [
      Section(name: "Mac", items: ["MacBook", "MacBook Air"])
    ]
}
