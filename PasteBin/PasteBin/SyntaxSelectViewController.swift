//
//  SyntaxSelectViewController.swift
//  PasteBin
//
//  Created by Henrik Gustavii on 22/03/2018.
//  Copyright © 2018 JonLuca De Caro. All rights reserved.
//

import UIKit
import Highlightr
import SearchTextField

class SyntaxSelectViewController: UIViewController {

    let languages = SyntaxLibraries().languages

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var syntaxPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var searchSyntaxTextField: SearchTextField!
    
    var syntax: String = ""
    var syntaxIndex: Int = 0

    // Function type that can be accessed from Callback VC (PasteView.swift)
    var onSave: ((_ data: String, _ index: Int) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        syntaxPicker.delegate = self
        syntaxPicker.dataSource = self
        titleLabel.text = syntax
        syntaxPicker.selectRow(syntaxIndex, inComponent: 0, animated: true)
        
        // SearchTextField settings
        searchSyntaxTextField.filterStrings(languages)
        searchSyntaxTextField.theme.bgColor = UIColor (red: 1, green: 1, blue: 1, alpha: 0.95)
        
        // Handles what happens when user picks an item
        searchSyntaxTextField.itemSelectionHandler = { item, itemPosition in
            let item = item[itemPosition]
            self.searchSyntaxTextField.text = item.title
            self.syntax = item.title
            
            if self.languages.contains(self.syntax) {
                self.syntaxIndex = self.languages.index(of: self.syntax)!
                self.syntaxPicker.selectRow(self.syntaxIndex, inComponent: 0, animated: true)
                self.titleLabel.text = self.languages[self.syntaxIndex]
            }
        }
    }

    // Sends syntax choice to pasteview and dismisses popup
    @IBAction func saveSyntax_TouchUpInside(_ sender: UIButton) {
        
        onSave?(syntax, syntaxIndex)
        
        dismiss(animated: true)
    }
    
    @IBAction func backPress(_ sender: UIButton) {
        
        dismiss(animated: true)
        
    }
    
    // Makes keyboard disappear by touching outside popup keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// UIPickerView setup
extension SyntaxSelectViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        titleLabel.text = languages[row]
        syntax = languages[row]
        syntaxIndex = row
    }
}
