//
//  EditProfileViewController.swift
//  Wanda
//
//  Created by Courtney Bell on 2/6/21.
//  Copyright © 2021 Bell, Courtney. All rights reserved.
//

import FirebaseAuth
import Foundation
import MessageUI
import UIKit

class EditProfileViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WandaAlertViewDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var bioTextCounterLabel: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var languagesView: UIView!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var languaguesTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailIncorrectLabel: UILabel!
    @IBOutlet weak var cellPhoneIncorrectLabel: UILabel!
    @IBOutlet weak var cellPhoneView: UIView!
    @IBOutlet weak var cellPhoneLabel: UILabel!
    @IBOutlet weak var cellPhoneTextField: UITextField!
    @IBOutlet weak var cellPhoneSwitch: UISwitch!
    @IBOutlet weak var cellPhonePrivateLabel: UILabel!
    @IBOutlet weak var cellPhonePublicLabel: UILabel!
    @IBOutlet weak var emailSwitch: UISwitch!
    @IBOutlet weak var emailPrivateLabel: UILabel!
    @IBOutlet weak var emailPublicLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var nameEmptyLabel: UILabel!
    
    var imagePicker = UIImagePickerController()
    var unsavedChanges = false
    private var menuView: WandaMenu?
    private var tap: UITapGestureRecognizer!

//    private var dropDown: LanguagesDropDown?



    static let storyboardIdentifier = String(describing: EditProfileViewController.self)
    private var dataManager = WandaDataManager.shared

    let bioPlaceholderText =  "'Here is your bio, let your cohort know a bit about you. If you have preferences for how to be contacted let other moms know here :)'"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roundViews()
        underlineViews()
        addImagesToTextFields()

//        let pickerView = UIPickerView()
//        pickerView.delegate = self
//        pickerView.showsSelectionIndicator = true

        emailTextField.delegate = self
        nameTextField.delegate = self
        languaguesTextField.delegate = self
        bioTextView.delegate = self
        cellPhoneTextField.delegate = self
//        languaguesTextField.inputView = LanguagesDropDown(frame: CGRect(x: 0, y: 0, width: 250, height: 96))
//        languaguesTextField.inputView = pickerView
        
        if let motherId =  dataManager.wandaMother?.motherId {
            let downloadURL = URL(string: "https://wanda-photos-bucket.s3-us-west-2.amazonaws.com/\(motherId)")!
            profileImage.af.setImage(withURL: downloadURL)
            if profileImage.image != nil {
                addImageButton.imageView?.tintColor = UIColor(hexString: "#E0E0E0")
            } else {
                showInitialView()
            }
        } else {
            showInitialView()
        }
        
        tap = UITapGestureRecognizer(target: self, action: #selector(hideMenuIfPossible))
        self.tap.delegate = self
        self.scrollView.addGestureRecognizer(tap)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
//        TO DO - can bring these back but it doesnt scale properly
//        emailSwitch.transform = CGAffineTransform(scaleX: 0.95, y: 0.85)
//        cellPhoneSwitch.transform = CGAffineTransform(scaleX: 0.95, y: 0.85)
    }
    
    @objc
    func hideMenuIfPossible() {
        guard menuView?.contentView.isHidden == false else {
            return
        }
        
        menuView?.toggleMenu()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideMenuIfPossible()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let menuView = menuView else {
            return false
        }

        return !menuView.isHidden
    }
    
    func showInitialView() {
        let initialLabel = UILabel()
        initialLabel.frame.size = CGSize(width: 100.0, height: 100.0)
        initialLabel.backgroundColor = WandaColors.toggleOffGrey

        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(initialLabel.bounds.size, false, scale)
        initialLabel.layer.render(in: UIGraphicsGetCurrentContext()!)
        profileImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        addImageButton.tintColor = UIColor(hexString: "#8B8B8B")
        addImageButton.imageView?.tintColor = UIColor(hexString: "#8B8B8B")
    }
    
    
    func configureInfo() {
        guard let mother = dataManager.wandaMother else {
            logAnalytic(tag: WandaAnalytics.editProfileLoadError)
            return
        }
        
        if mother.name != "" {
            nameTextField.text = mother.name
            nameLabel.isHidden = false
        }
        
        if mother.bio?.isEmpty == false, let bio = mother.bio {
            bioTextView.text = bio
        }
        
        if mother.shareContactEmail == true {
            emailSwitch.isOn = true
            toggleEmailSwitch()
        } else {
            emailSwitch.isOn = false
            toggleEmailSwitch()
        }
            
        if let email = mother.contactEmail, email.isEmpty == false {
            emailLabel.isHidden = false
            emailTextField.text = email
        }
        
        if mother.sharePhoneNumber == true {
            cellPhoneSwitch.isOn = true
            toggleCellPhoneSwitch()
        } else {
            cellPhoneSwitch.isOn = false
            toggleCellPhoneSwitch()
        }
        
        if let phoneNumber = mother.phoneNumber, phoneNumber.isEmpty == false {
            cellPhoneLabel.isHidden = false
            cellPhoneTextField.text = phoneNumber
        }
        
        if mother.languages.isEmpty == false && mother.languages[0] != "" {
            languagesLabel.isHidden = false
            languaguesTextField.text = configureLanguagesText(mother.languages)
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
    
    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//   // Sets the number of rows in the picker view
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//       return languages.count
//   }
//
//
//   // This function sets the text of the picker view to the content of the "languages" array
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//       return languages[row]
//   }

   // When user selects an option, this function will set the text of the text field to reflect
   // the selected option.
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//       languaguesTextField.text = languages[row]
//   }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = contentView.frame.size
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationBar()
                
        configureInfo()
        
        configureMenu()
        
        setupBioViewPlaceholder()

        
//        configureDropDown()
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
//
//    private func configureDropDown() {
//        dropDown = LanguagesDropDown(frame: CGRect(x: 500, y: 500, width: 250, height: 96))
//        if let dropDown = dropDown {
//            dropDown.frame.origin.y = 0
//            dropDown.frame.origin.x = self.view.frame.width - dropDown.frame.width
//
//            self.view.addSubview(dropDown)
//            self.view.bringSubview(toFront: dropDown)
//        }
//
////        menuView?.logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
////        menuView?.contactUsButton.addTarget(self, action: #selector(didTapContactWanda), for: .touchUpInside)
//    }
    
    @objc
    func didTapLogoutButton() {
        do {
            try Auth.auth().signOut()
        } catch {
            // We are currently failing silently and sending the user back to the LoginViewController.
            logAnalytic(tag: WandaAnalytics.editProfileOverflowMenuLogoutError)
            print("Couldn't sign user out. Returning back to Login.")
        }
        popBack(toControllerType: LoginViewController.self)
    }
    
    @objc
    private func didTapContactWanda() {
        guard let contactUsViewController = ViewControllerFactory.makeContactUsViewController(for: .editProfile) else {
            logAnalytic(tag: WandaAnalytics.editProfileOverflowMenuContactWandaError)
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
    
    
    private func configureNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false

        navigationController?.view.backgroundColor = WandaColors.lightPurple
        if let navigationBar = self.navigationController?.navigationBar {
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
    
    @objc
    private func didTapOverflowMenu() {
        if let menuView = menuView {
            menuView.toggleMenu()
        }
    }
    
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        if unsavedChanges {
            self.presentErrorAlert(for: .unsavedChanges)
        } else {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func didTapActionButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupBioViewPlaceholder() {
        self.bioTextView.delegate = self
        let bio = dataManager.wandaMother?.bio ?? ""
        if bio == "" {
            bioTextView.textColor = UIColor.lightGray
            bioTextView.text = bioPlaceholderText
        } else {
            bioTextCounterLabel.text = "\(bioTextView.text.count)/\(maxLength)"
            bioTextView.textColor = WandaColors.black87
            bioTextView.text = bio
        }
    }
    
    let maxLength = 300
    
    func textViewDidChange(_ textView: UITextView) {
        bioTextCounterLabel.text = "\(textView.text.count)/\(maxLength)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= maxLength
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
        unsavedChanges = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if bioTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty  == true {
            bioTextView.text = bioPlaceholderText
            bioTextView.textColor = UIColor.lightGray
        }
        bioView.underlinedView(color: WandaColors.black87.cgColor)
    }
    
    func profileTextFieldEditingDidBegin(_ textField: UITextField, _ label: UILabel, _ placeholder: String) {
        label.textColor = WandaColors.brightPurple
        if textField.text == placeholder || textField.text == ""  {
            UIView.animate(
                withDuration: 0.1,
                delay: 0.0,
                options: .curveLinear,
                animations: {
                    textField.placeholder = ""
                    label.isHidden = false
                    label.frame.origin.y = label.frame.origin.y - 4
            })
        }
        
        textField.underlined(color: WandaColors.brightPurple.cgColor)
        unsavedChanges = true
    }
    
    func profileTextFieldEditingDidEnd(_ textField: UITextField, _ label: UILabel, _ placeholder: String) {
        if textField.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            let test = label.frame.origin.y + 4
            UIView.animate(
                withDuration: 0.1,
                delay: 0.0,
                options: .curveLinear,
                animations: {
                    label.frame.origin.y = test
                    label.isHidden = true
                    textField.text = ""
                    textField.placeholder = placeholder
            })
            
        }
        label.textColor = WandaColors.lightBlack
        textField.underlined(color: UIColor.black.cgColor)
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    @IBAction func didTapUpdateProfile() {
        guard let email = emailTextField.text, let cellPhone = cellPhoneTextField.text, let name = nameTextField.text else {
            self.logAnalytic(tag: WandaAnalytics.editProfileUpdateMotherError)
            // to do error handle
            return
        }
        
        var isCellPhoneValid = true
        if !cellPhone.isEmpty {
            isCellPhoneValid = checkCellPhoneIsValid(value: cellPhone)
            cellPhone.isCellPhoneValid(cellPhoneTextField: cellPhoneTextField, cellPhoneInfoLabel: cellPhoneIncorrectLabel, isValid: isCellPhoneValid)
        }
    
        if isCellPhoneValid {
            cellPhoneTextField.underlined(color: UIColor.black.cgColor)
        }
        
        // Email is valid if empty
        var isEmailValid = true
        if !email.isEmpty {
            isEmailValid = email.isEmailValid(emailTextField: emailTextField, emailInfoLabel: emailIncorrectLabel)
        }
        
        if isEmailValid == true {
            emailIncorrectLabel.textColor = WandaColors.black60
            emailIncorrectLabel.font = UIFont.wandaFontRegular(size: 12)
            emailIncorrectLabel.text = "This email will only be used for contact"
            emailTextField.underlined(color: UIColor.black.cgColor)
        }

        let isNameValid = !name.isEmpty
        if !isNameValid {
            name.isNameValid(nameTextField: nameTextField, nameInfoLabel: nameEmptyLabel, isValid: false)
        }
        
        guard  isCellPhoneValid == true, isEmailValid == true,
            isNameValid == true, let mother = dataManager.wandaMother else {
                return
        }

        var updatedBio: String? = nil
        if bioTextView.text != bioPlaceholderText {
            updatedBio = bioTextView.text
        }
        
        var languages: [String] = []
        if let languagesText = languaguesTextField.text {
            languages = languagesText.components(separatedBy: ", ")
        }
        
        let updatedMother = EditWandaMotherInfo(
            motherId: mother.motherId, firebaseId: mother.firebaseId, cohortId: mother.cohortId, name: name, email: mother.email, contactEmail: email, shareContactEmail: emailSwitch.isOn, sharePhoneNumber: cellPhoneSwitch.isOn, phoneNumber: cellPhone, bio: updatedBio, languages: languages)

        dataManager.updateWandMother(mother: updatedMother) { success, error in
            guard success else {
                // to do - test
                self.presentErrorAlert(for: .systemError)
                return
            }

            _ = self.navigationController?.popViewController(animated: true)
        }
    
    }
    
    @IBAction func didTapAddImage(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            print("Button capture")

            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        profileImage.image = image
        addImageButton.imageView?.tintColor = UIColor(hexString: "#E0E0E0")
        dataManager.profilePictureNeedsReload = true
        
        let jpegCompressionQuality: CGFloat = 0.1
        if let myProfileImage = profileImage.image, let newbase64String = UIImageJPEGRepresentation(myProfileImage, jpegCompressionQuality)?.base64EncodedString(), let mother = dataManager.wandaMother {
                dataManager.uploadMotherPhoto(motherId: String(mother.motherId), photo: newbase64String) { success, error in
                    guard success else {
//                        to do - test
                        self.logAnalytic(tag: WandaAnalytics.editProfileUpdatePhotoError)
                        self.presentErrorAlert(for: .systemError)
                        return
                    }
                }
            }
    }
    
    @IBAction func nameTextFieldEditingDidBegin(_ sender: UITextField) {
        profileTextFieldEditingDidBegin(nameTextField, nameLabel, "Name")
        unsavedChanges = true
    }

    @IBAction func nameTextFieldEditingDidEnd(_ sender: UITextField) {
        profileTextFieldEditingDidEnd(nameTextField, nameLabel, "Name")
    }
    
    @IBAction func languagesTextFieldEditingDidBegin(_ sender: UITextField) {
//        dropDown?.toggleLanguagesDropDown()
        profileTextFieldEditingDidBegin(languaguesTextField, languagesLabel, "Languages")
        unsavedChanges = true
    }
    
    @IBAction func languagesTextFieldEditingDidEnd(_ sender: UITextField) {
//        dropDown?.toggleLanguagesDropDown()
        profileTextFieldEditingDidEnd(languaguesTextField, languagesLabel, "Languages")
    }
    
    @IBAction func emailTextFieldEditingDidBegin(_ sender: UITextField) {
        profileTextFieldEditingDidBegin(emailTextField, emailLabel, "Email")
        emailLabel.text = "Email"
        unsavedChanges = true
    }
    
    @IBAction func emailTextFieldEditingDidEnd(_ sender: UITextField) {
        profileTextFieldEditingDidEnd(emailTextField, emailLabel, "Email")
        let email = emailTextField.text ?? ""
        var isEmailValid = true
        if !email.isEmpty {
            isEmailValid = email.isEmailValid(emailTextField: emailTextField, emailInfoLabel: emailIncorrectLabel)
        }
        if isEmailValid == true {
            emailIncorrectLabel.textColor = WandaColors.black60
            emailIncorrectLabel.font = UIFont.wandaFontRegular(size: 12)
            emailIncorrectLabel.text = "This email will only be used for contact"
            emailTextField.underlined(color: UIColor.black.cgColor)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == cellPhoneTextField) {
            cellPhoneTextField.underlined(color: WandaColors.brightPurple.cgColor)
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)

            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length

            if length == 0 || (length > 10) || length > 11 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int

                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()

            if (length - index) > 3 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", areaCode)
                index += 3
            }
            if length - index > 3 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }

            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            
            if cellPhoneIncorrectLabel.isHidden == false {
                cellPhoneIncorrectLabel.isHidden = true
            }
            
            return false
        }
        else if (textField == emailTextField) {
            if emailIncorrectLabel.isHidden == false {
                emailIncorrectLabel.isHidden = true
                emailIncorrectLabel.textColor = WandaColors.black60
                emailIncorrectLabel.font = UIFont.wandaFontRegular(size: 12)
                emailIncorrectLabel.text = "This email will only be used for contact"
                emailTextField.underlined(color: WandaColors.brightPurple.cgColor)
            }
            return true
        }
        else if (textField == nameTextField) {
            if nameEmptyLabel.isHidden == false {
                if !string.isEmpty {
                    nameEmptyLabel.isHidden = true
                    nameTextField.underlined(color: WandaColors.brightPurple.cgColor)
                }
            }
            return true
        }
        else {
            return true
        }
    }
    
    @IBAction func cellPhoneTextFieldEditingDidBegin(_ sender: UITextField) {
        profileTextFieldEditingDidBegin(cellPhoneTextField, cellPhoneLabel, "Cell Phone")
        unsavedChanges = true
    }
    
    @IBAction func cellPhoneTextFieldEditingDidEnd(_ sender: UITextField) {
        profileTextFieldEditingDidEnd(cellPhoneTextField, cellPhoneLabel, "Cell Phone")
        let cellPhone = cellPhoneTextField.text ?? ""
        var isCellPhoneValid = true
        if !cellPhone.isEmpty {
            isCellPhoneValid = checkCellPhoneIsValid(value: cellPhone)
            cellPhone.isCellPhoneValid(cellPhoneTextField: cellPhoneTextField, cellPhoneInfoLabel: cellPhoneIncorrectLabel, isValid: isCellPhoneValid)
        }
        
        if isCellPhoneValid == false {
            cellPhoneIncorrectLabel.isHidden = false
            cellPhoneTextField.underlined(color: WandaColors.newErrorRed.cgColor)
        } else {
            cellPhoneIncorrectLabel.isHidden = true
            cellPhoneTextField.underlined(color: UIColor.black.cgColor)
        }
    }
    
    func checkCellPhoneIsValid(value: String) -> Bool {
       let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
       let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
       let result = phoneTest.evaluate(with: value)
       return result
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
            var cgRect = CGRect(x: 18, y: 10, width: 24, height: 24)
            if value == WandaImages.person {
                cgRect = CGRect(x: 18, y: 10, width: 20, height: 20)
            }
            key?.addImage(cgRect, value)
        }
    }

    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        
        scrollView.contentSize = CGSize(width: 375, height: 800)
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        DispatchQueue.main.async {
            let userInfo = notification.userInfo!
            let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            var contentInset:UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = keyboardFrame.size.height + 60
            self.scrollView.contentInset = contentInset
        }
    }
    
    @objc
    private func keyboardWillHide(notification:NSNotification){
        DispatchQueue.main.async {
            let contentInset:UIEdgeInsets = UIEdgeInsets.zero
            self.scrollView.contentInset = contentInset
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.superview?.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}
