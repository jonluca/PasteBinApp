//
//  ViewController.swift
//  PasteBin
//
//  Created by JonLuca De Caro on 12/28/16.
//  Copyright © 2016 JonLuca De Caro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var create: UIButton!
    
    @IBAction func createPaste(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let pasteViewController : PasteView = mainStoryboard.instantiateViewController(withIdentifier: "pasteVC") as! PasteView
        self.present(pasteViewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
