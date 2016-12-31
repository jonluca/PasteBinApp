//
//  OptionsViewController.swift
//  PasteBin
//
//  Created by JonLuca De Caro on 12/29/16.
//  Copyright © 2016 JonLuca De Caro. All rights reserved.
//

import UIKit

class OptionsViewController: UITableViewController {
    
    @IBAction func save(_ sender: Any) {
        let defaults = UserDefaults.standard
        if unlistedSwitch.isOn {
            defaults.set(true, forKey: "SwitchState")
        } else {
            defaults.set(false, forKey: "SwitchState")
        }
        
//        defaults.set(, forKey: "textType")
        if(quickPasteTitle.text != nil){
            defaults.set(quickPasteTitle.text, forKey: "quickPasteTitle");
        }
        self.dismiss(animated: true, completion: {});
    }
    @IBOutlet weak var unlistedSwitch: UISwitch!
    
    @IBOutlet weak var quickPasteTitle: UITextField!
    @IBAction func unlistedChange(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if unlistedSwitch.isOn {
            defaults.set(true, forKey: "SwitchState")
        } else {
            defaults.set(false, forKey: "SwitchState")
        }
    }
    @IBAction func twitterHandle(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "http://www.twitter.com/jonlucadecaro")!)


    }
    
    @IBAction func donate(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=TV28RGXB52DUA")!)
    }
    @IBAction func pastebin(_ sender: Any) {
           UIApplication.shared.openURL(URL(string: "http://www.pastebin.com")!)
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        let defaults = UserDefaults.standard
        
        if (defaults.object(forKey: "SwitchState") != nil) {
            unlistedSwitch.isOn = defaults.bool(forKey: "SwitchState")
        }
        if(quickPasteTitle.text != nil){
            quickPasteTitle.text = defaults.string(forKey: "quickPasteTitle");
        }
    }
}
