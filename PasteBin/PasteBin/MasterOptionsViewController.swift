//
//  MasterOptionsViewController.swift
//  PasteBin
//
//  Created by Henrik Gustavii on 30/05/2018.
//  Copyright © 2018 JonLuca De Caro. All rights reserved.
//

import UIKit

class MasterOptionsViewController: UIViewController {

    static var previousStoryboardIsMainView = false
    
    @IBOutlet weak var optionsContainer: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        if MasterOptionsViewController.previousStoryboardIsMainView {
            // Transition to main view in order to reset background scrolling
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let vC: ViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainView") as! ViewController
            self.present(vC, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

}
