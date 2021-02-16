//
//  EditProfileViewController.swift
//  Wanda
//
//  Created by Courtney Bell on 2/6/21.
//  Copyright © 2021 Bell, Courtney. All rights reserved.
//

import Foundation
import UIKit

class EditProfileViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bioView: UIView!
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
    
    let bioPlaceholderText =  "'Here is your bio, let your cohort know a bit about you. If you have preferences for how to be contacted let other moms know here :)'"
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        roundViews()
        underlineViews()
        setupBioViewPlaceholder()
        addImagesToTextFields()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = contentView.frame.size
    }
    
    func setupBioViewPlaceholder() {
        self.bioTextView.delegate = self
        let bio = ""
        if bio == "" {
            bioTextView.textColor = UIColor.lightGray
            bioTextView.text = bioPlaceholderText
        }
    }
    
    func roundViews() {
        let profileViews = [bioView, nameView, languagesView, emailView, cellPhoneView]
        for view in profileViews {
            view?.roundCorners(corners: [.topLeft, .topRight], radius: 5.0)
        }
    }
    
    func underlineViews() {
        let profileTextFields = [nameTextField, languaguesTextField, emailTextField, cellPhoneTextField]
        for textField in profileTextFields {
            textField?.underlined(color: UIColor.black.cgColor)
        }
        // This view has to be done separately b/c it is a UIView not a UITextField
        bioView.underlinedView(color: UIColor.black.cgColor)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if bioTextView.text == bioPlaceholderText {
            bioTextView.text = ""
            bioTextView.textColor = UIColor.black
        }
        bioView.underlinedView(color: WandaColors.brightPurple.cgColor)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if bioTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty  == true {
            bioTextView.text = bioPlaceholderText
            bioTextView.textColor = UIColor.lightGray
        }
        bioView.underlinedView(color: UIColor.black.cgColor)
    }
    
    func profileTextFieldEditingDidBegin(_ textField: UITextField, _ label: UILabel) {
        textField.placeholder = ""
        label.textColor = WandaColors.brightPurple
        label.isHidden = false
        textField.underlined(color: WandaColors.brightPurple.cgColor)
    }
    
    func profileTextFieldEditingDidEnd(_ textField: UITextField, _ label: UILabel, _ placeholder: String) {
        if textField.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            label.isHidden = true
            textField.text = ""
            textField.placeholder = placeholder
        }
        label.textColor = WandaColors.lightBlack
        textField.underlined(color: UIColor.black.cgColor)
    }
    
    @IBAction func nameTextFieldEditingDidBegin(_ sender: UITextField) {
        profileTextFieldEditingDidBegin(nameTextField, nameLabel)
    }
    
    @IBAction func nameTextFieldEditingDidEnd(_ sender: UITextField) {
        profileTextFieldEditingDidEnd(nameTextField, nameLabel, "Name")
    }
    
    @IBAction func languagesTextFieldEditingDidBegin(_ sender: UITextField) {
        profileTextFieldEditingDidBegin(languaguesTextField, languagesLabel)
    }
    
    @IBAction func languagesTextFieldEditingDidEnd(_ sender: UITextField) {
        profileTextFieldEditingDidEnd(languaguesTextField, languagesLabel, "Languages")
    }
    
    @IBAction func emailTextFieldEditingDidBegin(_ sender: UITextField) {
        profileTextFieldEditingDidBegin(emailTextField, emailLabel)
    }
    
    @IBAction func emailTextFieldEditingDidEnd(_ sender: UITextField) {        profileTextFieldEditingDidEnd(emailTextField, emailLabel, "Email")
    }
    
    @IBAction func cellPhoneTextFieldEditingDidBegin(_ sender: UITextField) {
        profileTextFieldEditingDidBegin(cellPhoneTextField, cellPhoneLabel)
    }
    
    @IBAction func cellPhoneTextFieldEditingDidEnd(_ sender: UITextField) {
        profileTextFieldEditingDidEnd(cellPhoneTextField, cellPhoneLabel, "Cell Phone")
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
