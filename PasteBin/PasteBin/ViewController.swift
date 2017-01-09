//
//  ViewController.swift
//  PasteBin
//
//  Created by JonLuca De Caro on 12/28/16.
//  Copyright © 2016 JonLuca De Caro. All rights reserved.
//

import UIKit
import AFNetworking
import DynamicBlurView

class ViewController: UIViewController {
    
    @IBOutlet weak var create: UIButton!
    
    @IBAction func createPaste(_ sender: Any) {
        self.last = self.codeBackground.frame.origin.x;

        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let pasteViewController : PasteView = mainStoryboard.instantiateViewController(withIdentifier: "pasteVC") as! PasteView;
        self.present(pasteViewController, animated: false, completion: nil);
    }
    @IBOutlet weak var codeBackground: UIImageView!
    
    //init view vars
    var width = CGFloat(0);
    var last = CGFloat(-1400);
    var result = "null";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard;
        if (defaults.object(forKey: "selectedText") == nil) {
            defaults.set(145, forKey: "selectedText");
        }
        
        let bounds = UIScreen.main.bounds;
        self.width = bounds.size.width;
        backgroundInfinite()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.last = self.codeBackground.frame.origin.x;
    }
    
    func backgroundInfinite(){
        
        self.codeBackground.frame.origin.x = self.last;
        
        UIView.animate(withDuration: 10.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.codeBackground.frame.origin.x += self.width;
            
        }, completion: nil)
    }
    
    @IBAction func about(_ sender: Any) {
        
        self.last = self.codeBackground.frame.origin.x;
        
        let alertController = UIAlertController(title: "About", message: "© JonLuca De Caro 2017\n© pastebin.com", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true){
            
        }
    }
    
    @IBAction func helpButton(_ sender: Any) {
        self.last = self.codeBackground.frame.origin.x;

    }
    @IBAction func quickSubmit(_ sender: Any) {
        if let text = UIPasteboard.general.string {
            if(text.isEmpty){
                let alertController = UIAlertController(title: "Error!", message: "Text cannot be empty!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // handle response here.
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true){
                    
                }
            }else{
                if(isInternetAvailable()){
                    
                    let defaults = UserDefaults.standard
                    
                    let api_dev_key = "&api_dev_key=" + "71788ef035e5bf63bbbd11945bd8441c";
                    var api_paste_private = "&api_paste_private=";
                    
                    if(defaults.bool(forKey: "SwitchState")){
                        api_paste_private += "1"; // 0=public 1=unlisted 2=private
                    }else{
                        api_paste_private += "0";
                    }
                    
                    var api_paste_name = "&api_paste_name=";
                    // name or title of your paste
                    let titleText = defaults.string(forKey: "quickPasteTitle");
                    if(titleText == nil || (titleText?.isEmpty)!){
                        api_paste_name += "Created with Pastebin App";
                    }else{
                        api_paste_name += titleText!;
                    }
                    
                    let api_paste_expire_date = "&api_paste_expire_date=" + "N";
                    
                    let api_paste_format = "&api_paste_format=" + "text";
                    
                    let api_user_key = "&api_user_key=" + ""; // if an invalid api_user_key or no key is used, the paste will be create as a guest
                    let encoded_text = "&api_paste_code=" + (text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!;
                    
                    let encoded_title = api_paste_name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed);
                    
                    
                    var request = URLRequest(url: URL(string: "http://pastebin.com/api/api_post.php")!)
                    request.httpMethod = "POST"
                    
                    //convoluted but necessary for their post api
                    var postString = "api_option=paste";
                    postString +=  api_user_key;
                    postString += api_paste_private;
                    postString += encoded_title!;
                    postString += api_paste_expire_date;
                    postString += api_paste_format;
                    postString += api_dev_key + encoded_text;
                    
                    request.httpBody = postString.data(using: .utf8)
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data, error == nil else {
                            //if not connected to internet
                            print("error=\(error)")
                            return
                        }
                        
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                            print("statusCode should be 200, but is \(httpStatus.statusCode)")
                            print("response = \(response)")
                            let alertController = UIAlertController(title: "Error!", message: "Unknown error - HTTP Code" + String(httpStatus.statusCode), preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                // handle response here.
                            }
                            alertController.addAction(OKAction)
                            self.present(alertController, animated: true){
                                
                            }
                        }
                        
                        let responseString = String(data: data, encoding: .utf8)
                        self.result = responseString!;
                        print("responseString = \(responseString)")
                        UIPasteboard.general.string = responseString;
                        let alertController = UIAlertController(title: "Success!", message: responseString! + "\nSuccesfully copied to clipboard!", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            // handle response here.
                        }
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true){
                            
                        }
                    }
                    task.resume()
                }else{
                    let alertController = UIAlertController(title: "Error!", message: "Not connected to the internet!", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        // handle response here.
                    }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true){
                        
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        backgroundInfinite();
    }
    
    //credit to http://stackoverflow.com/questions/39558868/check-internet-connection-ios-10
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}

