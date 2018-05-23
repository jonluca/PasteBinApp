//
//  Toolbar.swift
//  PasteBin
//
//  Created by Henrik Gustavii on 17/05/2018.
//  Copyright © 2018 JonLuca De Caro. All rights reserved.
//

import UIKit

class Toolbar: UIToolbar {

    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    //    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    var middleBarButton: UIBarButtonItem!
    var rightBarButton: UIBarButtonItem!
    var rightBarButton2: UIBarButtonItem!
    
    
    //        // Setting up toolbar button items
    //        let button1 = UIButton(type: .system)
    //        button1.setImage(UIImage(named: "IconAbout.png"), for: .normal)
    //        button1.setTitle("About", for: .normal)
    //        button1.sizeToFit()
    //        let button2 = UIButton(type: .system)
    //        button2.setImage(UIImage(named: "IconHistory.png"), for: .normal)
    //        button2.setTitle("History", for: .normal)
    //        button2.sizeToFit()
    //        self.middleBarButton = UIBarButtonItem(customView: button2)
    
//    
//    let view = UIView()
//    let button = UIButton(type: .system)
//    button.semanticContentAttribute = .forceRightToLeft
//    button.setImage(UIImage(named: "IconAbout"), for: .normal)
//    button.setTitle("About", for: .normal)
//    button.addTarget(self, action: #selector(about), for: .touchUpInside)
//    button.sizeToFit()
//    view.addSubview(button)
//    view.frame = button.bounds
//    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: view)
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
