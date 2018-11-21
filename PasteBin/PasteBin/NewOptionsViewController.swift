//
//  NewOptionsViewController.swift
//  PasteBin
//
//  Created by Henrik Gustavii on 26/05/2018.
//  Copyright © 2018 JonLuca De Caro. All rights reserved.
//

import UIKit

class NewOptionsViewController: UITableViewController {
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var unlistedSwitch: UISwitch!
    @IBOutlet var syntaxSwitch: UISwitch!

    @IBOutlet var quickPasteTitle: UITextField!

    let languages = SyntaxLibraries().languages

    var previousStoryboardIsMainView = MasterOptionsViewController.previousStoryboardIsMainView

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        // Set Unlisted
        if defaults.object(forKey: "SwitchState") != nil {
            unlistedSwitch.isOn = defaults.bool(forKey: "SwitchState")
        }
        // Set language
        if defaults.object(forKey: "selectedText") != nil {
            textLabel.text = languages[defaults.integer(forKey: "selectedText")]
        } else {
            textLabel.text = "None"
            defaults.set(145, forKey: "selectedText")
        }
        // Set Syntax highlighter
        if defaults.object(forKey: "SyntaxState") != nil {
            syntaxSwitch.isOn = defaults.bool(forKey: "SyntaxState")
        }
        // Set quickpaste title
        if quickPasteTitle.text != nil {
            quickPasteTitle.text = defaults.string(forKey: "quickPasteTitle")
        }

        tableView.isScrollEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard

        if defaults.object(forKey: "SwitchState") != nil {
            unlistedSwitch.isOn = defaults.bool(forKey: "SwitchState")
        }
        // Populates text before it shows, to prevent animation lags
        if defaults.object(forKey: "selectedText") != nil {
            textLabel.text = languages[defaults.integer(forKey: "selectedText")]
        } else {
            textLabel.text = "None"
            defaults.set(145, forKey: "selectedText")
        }
        if defaults.object(forKey: "SyntaxState") != nil {
            syntaxSwitch.isOn = defaults.bool(forKey: "SyntaxState")
        }
    }

    @IBAction func save(_: Any) {
        let defaults = UserDefaults.standard
        if unlistedSwitch.isOn {
            defaults.set(true, forKey: "SwitchState")
        } else {
            defaults.set(false, forKey: "SwitchState")
        }
        if quickPasteTitle.text != nil {
            defaults.set(quickPasteTitle.text, forKey: "quickPasteTitle")
        }

        if syntaxSwitch.isOn {
            defaults.set(true, forKey: "SyntaxState")
        } else {
            defaults.set(false, forKey: "SyntaxState")
        }
        if quickPasteTitle.text != nil {
            defaults.set(quickPasteTitle.text, forKey: "quickPasteTitle")
        }

        // Transition to main view in order to reset background scrolling
        if previousStoryboardIsMainView {
            // Transition to main view in order to reset background scrolling
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vC: ViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainView") as! ViewController
            present(vC, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func unlistedChange(_: Any) {
        let defaults = UserDefaults.standard

        if unlistedSwitch.isOn {
            defaults.set(true, forKey: "SwitchState")
        } else {
            defaults.set(false, forKey: "SwitchState")
        }
    }

    @IBAction func syntaxChange(_: Any) {
        let defaults = UserDefaults.standard

        if syntaxSwitch.isOn {
            defaults.set(true, forKey: "SyntaxState")
        } else {
            defaults.set(false, forKey: "SyntaxState")
        }
    }

    // Twitter
    @IBAction func twitterHandle(_: Any) {
        UIApplication.shared.open(URL(string: "http://www.twitter.com/jonlucadecaro")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }

    // Donate
    @IBAction func donate(_: Any) {
        UIApplication.shared.open(URL(string: "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=TV28RGXB52DUA")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }

    // Pastebin
    @IBAction func pastebin(_: Any) {
        UIApplication.shared.open(URL(string: "http://www.pastebin.com")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value) })
}
