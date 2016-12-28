//
//  PasteView.swift
//  PasteBin
//
//  Created by JonLuca De Caro on 12/28/16.
//  Copyright © 2016 JonLuca De Caro. All rights reserved.
//

import UIKit

class PasteView: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isEnabled = false;
        doneButton.title = nil;
        let tapOutTextField: UITapGestureRecognizer = UITapGestureRecognizer(target: textView, action: #selector(edit));
        textView.delegate = self;
        textView.addGestureRecognizer(tapOutTextField);
        view.addGestureRecognizer(tapOutTextField)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet weak var submitButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBAction func done(_ sender: Any) {
        doneButton.title = nil;
        doneButton.isEnabled = false;
        view.endEditing(true);
        submitButton.isEnabled = true;
        submitButton.title = "Submit";

    }
    func edit(){
        submitButton.isEnabled = false;
        submitButton.title = nil;
        
        doneButton.title = "Done";
        doneButton.isEnabled = true;
    }
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func submit(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        edit();
    }
    func textViewDidChange(_ textView: UITextView) {
        submitButton.isEnabled = false;
        submitButton.title = nil;
        
        doneButton.title = "Done";
        doneButton.isEnabled = true;
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
