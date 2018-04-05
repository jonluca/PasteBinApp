//
//  TextSelectionViewController.swift
//  PasteBin
//
//  Created by JonLuca De Caro on 1/9/17.
//  Copyright © 2017 JonLuca De Caro. All rights reserved.
//

import UIKit
import SearchTextField

class TextSelectionViewController: UITableViewController {

    //All available languages from the pastebin API
    let languages = SyntaxLibraries().languages

    var syntaxIndex: Int = 0
    var syntax = ""
    
    @IBOutlet weak var searchSyntaxTextField: SearchTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Picks up the user default syntax/language
        let defaults = UserDefaults.standard
        syntaxIndex = defaults.integer(forKey: "selectedText")
        syntax = languages[defaults.integer(forKey: "selectedText")]
        
        let indexPath = IndexPath(row: self.syntaxIndex, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
        // SearchTextField settings
        searchSyntaxTextField.filterStrings(languages)

        // Handles what happens when user picks an item
        searchSyntaxTextField.itemSelectionHandler = { item, itemPosition in
            let item = item[itemPosition]
            self.searchSyntaxTextField.text = item.title
            self.syntax = item.title

            if self.languages.contains(self.syntax) {
                self.syntaxIndex = self.languages.index(of: self.syntax)!
                let indexPath = IndexPath(row: self.syntaxIndex, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }

    @IBAction func donePress(_ sender: Any) {
        self.dismiss(animated: true) {
        };
    }

    //251 Languages, for reference
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Select Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath as IndexPath);
        //Label it from languages and index
        cell.textLabel?.text = languages[indexPath.item];

        //Open savefile
        let defaults = UserDefaults.standard

        //If save already exists
        if (defaults.object(forKey: "selectedText") != nil) {
            if (indexPath.item == defaults.integer(forKey: "selectedText")) {
                cell.accessoryType = .checkmark;
            } else {
                cell.accessoryType = .none;
            }
        } else {
            let indPath = IndexPath(row: 145, section: 0)
            if let cell = tableView.cellForRow(at: indPath) {
                cell.accessoryType = .checkmark;
            }
        }
        return cell;
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Puts a checkmark on the selected one
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark;
        }
        //Bad Code Alert! I should be saving it as a local variable and then dynamically changing it/setting it to unchecked. But this gets around manual edits to the plist on jailbroken systems 😎
        for i in 0..<languages.count {
            if (i == indexPath.item) {
                continue;
            }
            let indPath = IndexPath(row: i, section: 0)
            if let cell = tableView.cellForRow(at: indPath) {
                cell.accessoryType = .none;
            }
        }

        //Saves the int of the selected languages item
        let defaults = UserDefaults.standard
        defaults.set(indexPath.item, forKey: "selectedText");
    }

    //Should deselect the selected one... But it only works after the initial selection, so hacky workaround above
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none;
        }
    }

}
