//
//  PasteView.swift
//  PasteBin
//
//  Created by JonLuca De Caro on 12/28/16.
//  Copyright © 2016 JonLuca De Caro. All rights reserved.
//

import UIKit
import AFNetworking
import Highlightr

class PasteView: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate {
    var isCurrentlyEditing = false;

    // Previous pastes array
    var savedList: [String] = []

    var submitButtonState: Bool = true

    let highlightr = Highlightr()
    var syntaxIndex: Int = 0
    var syntaxPastebin: String = "Syntax"
    var syntaxHighlightr: String = ""

    let languages = SyntaxLibraries().languages
    let highlightrSyntax = SyntaxLibraries().highlightrLanguage
    let postLanguage = SyntaxLibraries().postLanguage

    override func viewDidLoad() {
        super.viewDidLoad()
        //Don't judge for the following code - fairly redundant but works
        let tapOutTextField: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(edit));
        textView.delegate = self;
        textView.addGestureRecognizer(tapOutTextField);
        view.addGestureRecognizer(tapOutTextField)

        // Load previous pastes to savedList array
        savedList = PastebinHelper().loadSavedListItems()

        // Sets the theme of syntax highlighter. Could be made a choice in the future in Options menu.
        highlightr?.setTheme(to: "github-gist")

        // Picks up the user default syntax/language that was set in options menu/view
        let defaults = UserDefaults.standard
        syntaxIndex = defaults.integer(forKey: "selectedText")
        syntaxPastebin = languages[syntaxIndex]
        syntaxHighlightr = highlightrSyntax[syntaxPastebin]!

    }

    @IBOutlet weak var titleText: UITextField!


    @IBAction func editAction(_ sender: Any) {
        titleText.text = "";
    }

    @IBOutlet weak var submitButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!

    @IBAction func backButtonAction(_ sender: Any) {
        if (!isCurrentlyEditing) {
            if (textView.text?.isEmpty)! {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil);
                let vC: ViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainView") as! ViewController;
                self.present(vC, animated: false, completion: nil);
            } else {
                let alertController = UIAlertController(title: "Are you sure?", message: "You'll lose all text currently in the editor", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil);
                    let vC: ViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainView") as! ViewController;
                    self.present(vC, animated: false, completion: nil);
                }
                alertController.addAction(OKAction)
                let NoActions = UIAlertAction(title: "Cancel", style: .default) { (action) in

                }
                alertController.addAction(NoActions)

                self.present(alertController, animated: true) {

                }
            }

        } else {
            // Pops up syntax selector popup if in Editing State
            selectSyntax()
        }
    }

    @objc func edit() {
        isCurrentlyEditing = true
        submitButtonState = false
        
        let defaults = UserDefaults.standard
        if (defaults.bool(forKey: "SyntaxState") == true) {
            backButton.title = syntaxPastebin
        } else {
            backButton.isEnabled = false
            backButton.title = "Syntax Off"
        }

        submitButton.title = "Done"

    }

    @IBOutlet weak var textView: UITextView!

    @IBAction func submitButtonAction(_ sender: AnyObject!) {
        if submitButtonState {
            let text = textView.text;
            if (text?.isEmpty)! {
                let alertController = UIAlertController(title: "Error!", message: "Text cannot be empty!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // handle response here.
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true) {

                }
            } else {
                if (PastebinHelper().isInternetAvailable()) {

                    let defaults = UserDefaults.standard

                    let api_dev_key = "&api_dev_key=" + "71788ef035e5bf63bbbd11945bd8441c";
                    var api_paste_private = "&api_paste_private=";

                    if (defaults.bool(forKey: "SwitchState")) {
                        api_paste_private += "1";
                        // 0=public 1=unlisted 2=private
                    } else {
                        api_paste_private += "0";
                    }

                    var api_paste_name = "&api_paste_name=";
                    // name or title of your paste
                    if (titleText.text?.isEmpty)! {
                        api_paste_name += "Created with Pastebin App";
                    } else {
                        api_paste_name += titleText.text!;
                    }

                    let api_paste_expire_date = "&api_paste_expire_date=" + "N";

                    var api_paste_format = "&api_paste_format=";

                    if (defaults.object(forKey: "selectedText") != nil) {
                        api_paste_format += postLanguage[languages[syntaxIndex]]!
                    } else {
                        api_paste_format += "text";
                    }


                    let api_user_key = "&api_user_key=" + "";
                    // if an invalid api_user_key or no key is used, the paste will be create as a guest
                    let encoded_text = "&api_paste_code=" + (text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!;

                    let encoded_title = api_paste_name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed);


                    var request = URLRequest(url: URL(string: "https://pastebin.com/api/api_post.php")!)
                    request.httpMethod = "POST"

                    //convoluted but necessary for their post api
                    var postString = "api_option=paste";
                    postString += api_user_key;
                    postString += api_paste_private;
                    postString += encoded_title!;
                    postString += api_paste_expire_date;
                    postString += api_paste_format;
                    postString += api_dev_key + encoded_text;
                    
                    request.httpBody = postString.data(using: .utf8)
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data, error == nil else {
                            //if not connected to internet
                            print("error=\(String(describing: error))")
                            return
                        }

                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                            print("statusCode should be 200, but is \(httpStatus.statusCode)")
                            print("response = \(String(describing: response))")
                            var message = "Unknown error - HTTP Code" + String(httpStatus.statusCode)
                            if httpStatus.statusCode == 403 {
                                message = "Error 403 - PasteBin not allowed from this IP!"
                            }
                            let alertController = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                // handle response here.
                            }
                            alertController.addAction(OKAction)
                            self.present(alertController, animated: true) {

                            }
                        }

                        let responseString = String(data: data, encoding: .utf8)
                        UIPasteboard.general.string = responseString;

                        // Adding the link to the savedList array and then saving to drive
                        self.savedList.append(responseString!)
                        PastebinHelper().saveSavedListItems(savedList: self.savedList)

                        let alertController = UIAlertController(title: "Success!", message: responseString! + "\nSuccessfully copied to clipboard!", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            // handle response here.
                            self.textView.text = responseString;
                        }
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true) {

                        }
                    }
                    task.resume()
                } else {
                    let alertController = UIAlertController(title: "Error!", message: "Not connected to the internet!", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        // handle response here.
                    }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true) {

                    }
                }
            }
        } else {
            isCurrentlyEditing = false;
            backButton.title = "Back";
            view.endEditing(true);
            backButton.isEnabled = true
            submitButtonState = true;
            submitButton.title = "Submit";
            
            // Converts pasted/typed text into highlighted syntax if selected in options menu
            let defaults = UserDefaults.standard
            
            if (defaults.object(forKey: "SyntaxState") != nil && defaults.bool(forKey: "SyntaxState") == true) {
                let code = textView.text
                if syntaxHighlightr == "default" {
                    textView.attributedText = highlightr?.highlight(code!)
                } else if syntaxHighlightr == "none" {
                    textView.attributedText = NSAttributedString(string: code!)
                } else {
                    textView.attributedText = highlightr?.highlight(code!, as: syntaxHighlightr)
                }
            }
        }
    }
    

    // Syntax picker method with segue via code
    func selectSyntax() {

        let sb = UIStoryboard(name: "SyntaxSelectViewController", bundle: nil)
        let popup = sb.instantiateInitialViewController()! as! SyntaxSelectViewController
        popup.syntax = syntaxPastebin
        popup.syntaxIndex = syntaxIndex
        present(popup, animated: true)

        // Callback closure to fetch data from popup
        popup.onSave = { (data, index) in
            self.syntaxHighlightr = self.highlightrSyntax[data]!
            self.syntaxIndex = index
            self.syntaxPastebin = data
            self.backButton.title = self.syntaxPastebin
        }

    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        edit();
    }

    func textViewDidChange(_ textView: UITextView) {
        isCurrentlyEditing = true
        submitButtonState = false
        
        let defaults = UserDefaults.standard
        if (defaults.bool(forKey: "SyntaxState") == true) {
            backButton.title = syntaxPastebin
        } else {
            backButton.isEnabled = false
            backButton.title = "Syntax Off"
        }

        submitButton.title = "Done"
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        return true
    }

}
