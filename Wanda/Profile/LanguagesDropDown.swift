//
//  LanguagesDropDown.swift
//  Wanda
//
//  Created by Courtney Bell on 3/2/21.
//  Copyright © 2021 Bell, Courtney. All rights reserved.
//

import Foundation
import UIKit

class LanguagesDropDown: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var contentView: UIView!
    
    var selectedLanguages = [String]()
    
    let languages = [
        "Afrikaans", "Albanian", "Arabic", "Armenian", "Basque", "Bengali", "Bulgarian",
        "Catalan", "Cambodian", "Chinese (Mandarin)", "Croatian", "Czech", "Danish", "Dutch",
        "English", "Estonian", "Fiji", "Finnish", "French", "Georgian", "German", "Greek",
        "Gujarati", "Hebrew", "Hindi", "Hungarian", "Icelandic", "Indonesian", "Irish", "Italian",
        "Japanese", "Javanese", "Korean", "Latin", "Latvian", "Lithuanian", "Macedonian", "Malay",
        "Malayalam", "Maltese", "Maori", "Marathi", "Mongolian", "Nepali", "Norwegian", "Persian",
        "Polish", "Portuguese", "Punjabi", "Quechua", "Romanian", "Russian", "Samoan", "Serbian",
        "Slovak", "Slovenian", "Spanish", "Swahili", "Swedish", "Tamil", "Tatar", "Telugu", "Thai",
        "Tibetan", "Tonga", "Turkish", "Ukrainian", "Urdu", "Uzbek", "Vietnamese", "Welsh", "Xhosa"]
    
    class func nibName() -> String {
        return String(describing: self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let languagesTableViewCellNib = UINib(nibName: LanguagesTableViewCell.nibName(), bundle: nil)
        tableView.register(languagesTableViewCellNib, forCellReuseIdentifier: LanguagesTableViewCell.nibName())

        
        tableView.estimatedRowHeight = 56.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func toggleLanguagesDropDown() {
        var isHidden = false
        DispatchQueue.main.async {
            self.contentView.isHidden = !self.contentView.isHidden
            isHidden = self.contentView.isHidden
            if isHidden {
                self.bringSubview(toFront: self.contentView)
            } else {
                self.sendSubview(toBack: self.contentView)
            }
        }
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(LanguagesDropDown.nibName(), owner: self, options: nil)
        self.addSubview(contentView)
        self.contentView.isHidden = true
        self.tableView.allowsSelection = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return languages.count
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let languagesCell = tableView.dequeueReusableCell(withIdentifier: LanguagesTableViewCell.nibName(), for: indexPath) as? LanguagesTableViewCell else {
            return UITableViewCell()
        }
        
        languagesCell.languageLabel.text = languages[indexPath.row]

        return languagesCell
    }
    
    @objc
    func didTapLanguage(){
        
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = languages[indexPath.row]
        
        selectedLanguages.append(language)
        
        print(selectedLanguages)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("OH")
    }

}
