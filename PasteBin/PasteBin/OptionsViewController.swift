//
//  OptionsViewController.swift
//  PasteBin
//
//  Created by JonLuca De Caro on 12/29/16.
//  Copyright © 2016 JonLuca De Caro. All rights reserved.
//

import UIKit

class OptionsViewController: UITableViewController {

    @IBOutlet weak var textLabel: UILabel!
    
    let languages = SyntaxLibraries().languages

    @IBAction func save(_ sender: Any) {
        let defaults = UserDefaults.standard
        if unlistedSwitch.isOn {
            defaults.set(true, forKey: "SwitchState")
        } else {
            defaults.set(false, forKey: "SwitchState")
        }
        if (quickPasteTitle.text != nil) {
            defaults.set(quickPasteTitle.text, forKey: "quickPasteTitle");
        }

        if syntaxSwitch.isOn {
            defaults.set(true, forKey: "SyntaxState")
        } else {
            defaults.set(false, forKey: "SyntaxState")
        }
        if (quickPasteTitle.text != nil) {
            defaults.set(quickPasteTitle.text, forKey: "quickPasteTitle");
        }

        // Transition to main view in order to reset background scrolling
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let vC: ViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainView") as! ViewController;
        self.present(vC, animated: false, completion: nil)
    }

    @IBOutlet weak var unlistedSwitch: UISwitch!
    @IBOutlet weak var syntaxSwitch: UISwitch!

    @IBOutlet weak var quickPasteTitle: UITextField!

    @IBAction func unlistedChange(_ sender: Any) {
        let defaults = UserDefaults.standard

        if unlistedSwitch.isOn {
            defaults.set(true, forKey: "SwitchState")
        } else {
            defaults.set(false, forKey: "SwitchState")
        }
    }

    @IBAction func syntaxChange(_ sender: Any) {
        let defaults = UserDefaults.standard

        if syntaxSwitch.isOn {
            defaults.set(true, forKey: "SyntaxState")
        } else {
            defaults.set(false, forKey: "SyntaxState")
        }
    }

    //Twitter
    @IBAction func twitterHandle(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://www.twitter.com/jonlucadecaro")!, options: [:], completionHandler: nil);
    }

    //Donate
    @IBAction func donate(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=TV28RGXB52DUA")!, options: [:], completionHandler: nil)
    }

    //Pastebin
    @IBAction func pastebin(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://www.pastebin.com")!, options: [:], completionHandler: nil);
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        let defaults = UserDefaults.standard
        //Set Unlisted
        if (defaults.object(forKey: "SwitchState") != nil) {
            unlistedSwitch.isOn = defaults.bool(forKey: "SwitchState")
        }
        //Set language
        if (defaults.object(forKey: "selectedText") != nil) {
            textLabel.text = languages[defaults.integer(forKey: "selectedText")]
        } else {
            textLabel.text = "None";
            defaults.set(145, forKey: "selectedText");
        }
        //Set Syntax highlighter
        if (defaults.object(forKey: "SyntaxState") != nil) {
            syntaxSwitch.isOn = defaults.bool(forKey: "SyntaxState")
        }
        //Set quickpaste title
        if (quickPasteTitle.text != nil) {
            quickPasteTitle.text = defaults.string(forKey: "quickPasteTitle");
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        let defaults = UserDefaults.standard

        if (defaults.object(forKey: "SwitchState") != nil) {
            unlistedSwitch.isOn = defaults.bool(forKey: "SwitchState")
        }
        //Populates text before it shows, to prevent animation lags
        if (defaults.object(forKey: "selectedText") != nil) {
            textLabel.text = languages[defaults.integer(forKey: "selectedText")]
        } else {
            textLabel.text = "None";
            defaults.set(145, forKey: "selectedText");
        }
        if (defaults.object(forKey: "SyntaxState") != nil) {
            syntaxSwitch.isOn = defaults.bool(forKey: "SyntaxState")
        }
    }
}
