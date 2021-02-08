//
//  EditProfileViewController.swift
//  Wanda
//
//  Created by Courtney Bell on 2/6/21.
//  Copyright © 2021 Bell, Courtney. All rights reserved.
//

import Foundation
import UIKit

class EditProfileViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var languagesView: UIView!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var languaguesTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cellPhoneView: UIView!
    @IBOutlet weak var cellPhoneLabel: UILabel!
    @IBOutlet weak var cellPhoneTextField: UITextField!
    @IBOutlet weak var cellPhoneSwitch: UISwitch!
    @IBOutlet weak var cellPhonePrivateLabel: UILabel!
    @IBOutlet weak var cellPhonePublicLabel: UILabel!
    @IBOutlet weak var emailSwitch: UISwitch!
    @IBOutlet weak var emailPrivateLabel: UILabel!
    @IBOutlet weak var emailPublicLabel: UILabel!

    static let storyboardIdentifier = String(describing: EditProfileViewController.self)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        let profileTextFields = [bioTextView, nameView, languagesView, emailView, cellPhoneView]
        for textField in profileTextFields {
            textField?.roundCorners(corners: [.topLeft, .topRight], radius: 5.0)
            textField?.underlined(color: UIColor.black.cgColor)
        }
        
        addImagesToTextFields()
    }
    
    @IBAction func nameTextFieldEditingDidBegin(_ sender: UITextField) {
        nameTextField.placeholder = ""
        nameLabel.isHidden = false
    }
    
    @IBAction func nameTextFieldEditingDidEnd(_ sender: UITextField) {
        if nameTextField.text?.isEmpty == true {
            nameLabel.isHidden = true
            nameTextField.placeholder = "Name"
        }
    }
    
    @IBAction func languagesTextFieldEditingDidBegin(_ sender: UITextField) {
        languaguesTextField.placeholder = ""
        languagesLabel.isHidden = false
    }
    
    @IBAction func languagesTextFieldEditingDidEnd(_ sender: UITextField) {
        if languaguesTextField.text?.isEmpty == true {
            languagesLabel.isHidden = true
            languaguesTextField.placeholder = "Languages"
        }
    }
    
    @IBAction func emailTextFieldEditingDidBegin(_ sender: UITextField) {
        emailTextField.placeholder = ""
        emailLabel.isHidden = false
    }
    
    @IBAction func emailTextFieldEditingDidEnd(_ sender: UITextField) {
        if emailTextField.text?.isEmpty == true {
            emailLabel.isHidden = true
            emailTextField.placeholder = "Email"
        }
    }
    
    @IBAction func cellPhoneTextFieldEditingDidBegin(_ sender: UITextField) {
        cellPhoneTextField.placeholder = ""
        cellPhoneLabel.isHidden = false
    }
    
    @IBAction func cellPhoneTextFieldEditingDidEnd(_ sender: UITextField) {
        if cellPhoneTextField.text?.isEmpty == true {
            cellPhoneLabel.isHidden = true
            cellPhoneTextField.placeholder = "Cell Phone"
        }
    }
    
    @IBAction func textFieldEditingDidBegin(_ sender: UITextField) {
        sender.underlined(color: WandaColors.underlinePurple.cgColor)
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: UITextField) {
        sender.underlined(color: UIColor.black.cgColor)
    }

    @IBAction func toggleCellPhoneSwitch() {
        if cellPhoneSwitch.isOn {
            cellPhoneSwitch.thumbTintColor = WandaColors.thumbTintOn
            cellPhonePrivateLabel.textColor = WandaColors.toggleOffGrey
            cellPhonePublicLabel.textColor = UIColor.black
        } else {
            cellPhoneSwitch.thumbTintColor = WandaColors.thumbTintOff
            cellPhonePrivateLabel.textColor = UIColor.black
            cellPhonePublicLabel.textColor = WandaColors.toggleOffGrey
        }
    }

    @IBAction func toggleEmailSwitch() {
        if emailSwitch.isOn {
            emailSwitch.thumbTintColor = WandaColors.thumbTintOn
            emailPrivateLabel.textColor = WandaColors.toggleOffGrey
            emailPublicLabel.textColor = UIColor.black
        } else {
            emailSwitch.thumbTintColor = WandaColors.thumbTintOff
            emailPrivateLabel.textColor = UIColor.black
            emailPublicLabel.textColor = WandaColors.toggleOffGrey
        }
    }
    
    func addImagesToTextFields() {
        let imageSet = [nameTextField: WandaImages.person, languaguesTextField: WandaImages.languagesIcon, emailTextField: WandaImages.envelopeFilledIcon, cellPhoneTextField: WandaImages.phoneIcon]
        for (key, value) in imageSet {
            var cgRect = CGRect(x: 10, y: 10, width: 24, height: 24)
            if value == WandaImages.person {
                cgRect = CGRect(x: 10, y: 10, width: 20, height: 20)
            }
            key?.addImage(cgRect, value)
        }
    }

    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        
        scrollView.contentSize = CGSize(width: 375, height: 800)
    }
}
