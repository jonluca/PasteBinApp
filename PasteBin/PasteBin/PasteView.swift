//
//  PasteView.swift
//  PasteBin
//
//  Created by JonLuca De Caro on 12/28/16.
//  Copyright © 2016 JonLuca De Caro. All rights reserved.
//

import UIKit
import AFNetworking

class PasteView: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isEnabled = false;
        doneButton.title = nil;
        //Don't judge for the following code - fairly redudant but works
        let tapOutTextField: UITapGestureRecognizer = UITapGestureRecognizer(target: textView, action: #selector(edit));
        textView.delegate = self;
        textView.addGestureRecognizer(tapOutTextField);
        view.addGestureRecognizer(tapOutTextField)
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
        let text = textView.text;
        if(text?.isEmpty)!{
            let alertController = UIAlertController(title: "Error!", message: "Text cannot be empty!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // handle response here.
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true){
                
            }
        }else{
            let devKey = "71788ef035e5bf63bbbd11945bd8441c";
            
            
        }
        
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
