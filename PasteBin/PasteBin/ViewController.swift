//
//  ViewController.swift
//  PasteBin
//
//  Created by JonLuca De Caro on 12/28/16.
//  Copyright © 2016 JonLuca De Caro. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController {

    // Previous pastes array
    var savedList: [String] = []

    @IBOutlet weak var create: UIButton!
    @IBOutlet weak var quickSubmit: UIButton!

    @IBAction func createPaste(_ sender: Any) {
        self.last = self.codeBackground.frame.origin.x;

        //Show main paste view
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let pasteViewController: PasteView = mainStoryboard.instantiateViewController(withIdentifier: "pasteVC") as! PasteView;
        self.present(pasteViewController, animated: true, completion: nil);
    }

    @IBOutlet weak var codeBackground: UIImageView!

    //init view vars
    var width = CGFloat(0);
    var last = CGFloat(-1400);
    var result = "null";

    override func viewDidLoad() {
        super.viewDidLoad()

        //If no defaults exist in save, create them
        let defaults = UserDefaults.standard;
        if (defaults.object(forKey: "selectedText") == nil) {
            defaults.set(145, forKey: "selectedText");
        }
        if (defaults.object(forKey: "SyntaxState") == nil) {
            defaults.set(true, forKey: "SyntaxState")
        }

        // Load previous pastes to savedList array
        savedList = PastebinHelper().loadSavedListItems()
        
        // Lets the background animation resume after app has been in background
        NotificationCenter.default.addObserver(self, selector: #selector(backgroundInfinite), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Get screen size for animated background
        let bounds = UIScreen.main.bounds;
        self.width = bounds.size.width;
        backgroundInfinite()
        
    }

    //Hide top bar
    override var prefersStatusBarHidden: Bool {
        return true
    }

    //Remembers the last position of scrolling background
    override func viewDidDisappear(_ animated: Bool) {
        self.last = self.codeBackground.frame.origin.x;
    }

    @objc func backgroundInfinite() {

        self.codeBackground.frame.origin.x = self.last;

        //10s animation, moves horizontally and back again
        UIView.animate(withDuration: 10.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.codeBackground.frame.origin.x += self.width;

        }, completion: nil)
    }

    @IBAction func about(_ sender: Any) {

        //Yet again saves the position
        self.last = self.codeBackground.frame.origin.x;

        //About Information
        let alertController = UIAlertController(title: "About", message: "© JonLuca De Caro 2018\n© Henrik Gustavii 2018\n© pastebin.com", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Do nothing
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true) {

        }
    }

    @IBAction func helpButton(_ sender: Any) {
        self.last = self.codeBackground.frame.origin.x;

    }

    @IBAction func quickSubmit(_ sender: Any) {
        if let text = UIPasteboard.general.string {
            //Don't allow empty paste
            if (text.isEmpty) {

                let alertController = UIAlertController(title: "Error!", message: "Text cannot be empty!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // handle response here.
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true) {

                }
            } else {
                
                PastebinHelper().postToPastebin(text: text, savedList: savedList)
                
            }
        }
    }
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var backgroundColour: UIColor? {
        get {
            return UIColor(cgColor: layer.backgroundColor!)
        }
        set {
            layer.backgroundColor = newValue?.cgColor
        }
    }
}
