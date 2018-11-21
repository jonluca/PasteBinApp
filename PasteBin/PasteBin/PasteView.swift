//
//  PasteView.swift
//  PasteBin
//
//  Created by JonLuca De Caro on 12/28/16.
//  Copyright © 2016 JonLuca De Caro. All rights reserved.
//

import AFNetworking
import Highlightr
import UIKit

class PasteView: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate {
    var isCurrentlyEditing = false

    var previousStoryboardIsMainView = false

    // Previous pastes (history) array
    var savedList: [String] = []

    var submitButtonState: Bool = true

    let highlightr = Highlightr()
    var syntaxIndex: Int = 0
    var syntaxPastebin: String = "Syntax"
    var syntaxHighlightr: String = ""

    let languages = SyntaxLibraries().languages
    let highlightrSyntax = SyntaxLibraries().highlightrLanguage
    let postLanguage = SyntaxLibraries().postLanguage

    @IBOutlet var submitButton: UIBarButtonItem!
    @IBOutlet var backButton: UIBarButtonItem!

    @IBOutlet var titleText: UITextField!
    @IBOutlet var textView: UITextView!
    var placeholderLabel: UILabel!

    @IBAction func selectSyntaxButton() {
        selectSyntax()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Don't judge for the following code - fairly redundant but works
        let tapOutTextField: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(edit))
        textView.delegate = self
        textView.addGestureRecognizer(tapOutTextField)
        view.addGestureRecognizer(tapOutTextField)

        // Sets the theme of syntax highlighter. Could be made a choice in the future in Options menu.
        highlightr?.setTheme(to: "atom-one-dark")

        // Picks up the user default syntax/language that was set in options menu/view
        let defaults = UserDefaults.standard
        syntaxIndex = defaults.integer(forKey: "selectedText")
        syntaxPastebin = languages[syntaxIndex]
        syntaxHighlightr = highlightrSyntax[syntaxPastebin]!

        // Sets a floating placeholder in the text view
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter or paste code/text here..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (textView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)

        // Load previous pastes to savedList array
        savedList = PastebinHelper().loadSavedListItems()
    }

    @IBAction func editAction(_: Any) {
        titleText.text = ""
    }

    @IBAction func backButtonAction(_: Any) {
        if !isCurrentlyEditing {
            if (textView.text?.isEmpty)! {
                if previousStoryboardIsMainView {
                    // Transition to main view in order to reset background scrolling
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vC: ViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainView") as! ViewController
                    present(vC, animated: true, completion: nil)
                } else {
                    dismiss(animated: true, completion: nil)
                }
            } else {
                let alertController = UIAlertController(title: "Are you sure?", message: "You'll lose all text currently in the editor", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Yes", style: .default) { _ in
                    if self.previousStoryboardIsMainView {
                        // Transition to main view in order to reset background scrolling
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vC: ViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainView") as! ViewController
                        self.present(vC, animated: true, completion: nil)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                let NoActions = UIAlertAction(title: "Cancel", style: .default) { _ in
                }
                alertController.addAction(NoActions)

                present(alertController, animated: true) {}
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
        if defaults.bool(forKey: "SyntaxState") == true {
            backButton.title = syntaxPastebin
        } else {
            backButton.isEnabled = false
            backButton.title = "Syntax Off"
        }

        submitButton.title = "Done"
    }

    @IBAction func submitButtonAction(_: AnyObject!) {
        if submitButtonState {
            let text = textView.text
            if (text?.isEmpty)! {
                let alertController = UIAlertController(title: "Oops!", message: "Text cannot be empty!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
                    // handle response here.
                }
                alertController.addAction(OKAction)
                present(alertController, animated: true) {}
            } else {
                let defaults = UserDefaults.standard
                let postSyntax = (defaults.object(forKey: "selectedText") != nil) ? postLanguage[languages[syntaxIndex]] : "text"

                PastebinHelper().postToPastebin(text: text!, savedList: savedList, syntax: postSyntax!, titleText: titleText.text!)
            }

        } else {
            isCurrentlyEditing = false
            backButton.title = "Back"
            view.endEditing(true)
            backButton.isEnabled = true
            submitButtonState = true
            submitButton.title = "Submit"

            // Converts pasted/typed text into highlighted syntax if selected in options menu
            let defaults = UserDefaults.standard

            if defaults.object(forKey: "SyntaxState") != nil && defaults.bool(forKey: "SyntaxState") == true {
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
        popup.onSave = { data, index in
            self.syntaxHighlightr = self.highlightrSyntax[data]!
            self.syntaxIndex = index
            self.syntaxPastebin = data
            self.backButton.title = self.syntaxPastebin
        }
    }

    func textViewDidBeginEditing(_: UITextView) {
        edit()
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty

        isCurrentlyEditing = true
        submitButtonState = false

        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "SyntaxState") == true {
            backButton.title = syntaxPastebin
        } else {
            backButton.isEnabled = false
            backButton.title = "Syntax Off"
        }

        submitButton.title = "Done"
    }

    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
}
