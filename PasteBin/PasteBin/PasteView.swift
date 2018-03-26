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
    var syntaxLanguage: String = "Syntax"
    var syntaxLanguageHighlightr: String = "Syntax"
    
    var languages = ["4CS", "6502 ACME Cross Assembler", "6502 Kick Assembler", "6502 TASM/64TASS", "ABAP", "ActionScript", "ActionScript 3", "Ada", "AIMMS", "ALGOL 68", "Apache Log", "AppleScript", "APT Sources", "ARM", "ASM (NASM)", "ASP", "Asymptote", "autoconf", "Autohotkey", "AutoIt", "Avisynth", "Awk", "BASCOM AVR", "Bash", "Basic4GL", "Batch", "BibTeX", "Blitz Basic", "Blitz3D", "BlitzMax", "BNF", "BOO", "BrainFuck", "C", "C (WinAPI)", "C for Macs", "C Intermediate Language", "C#", "C++", "C++ (WinAPI)", "C++ (with Qt extensions)", "C: Loadrunner", "CAD DCL", "CAD Lisp", "CFDG", "ChaiScript", "Chapel", "Clojure", "Clone C", "Clone C++", "CMake", "COBOL", "CoffeeScript", "ColdFusion", "CSS", "Cuesheet", "D", "Dart", "DCL", "DCPU-16", "DCS", "Delphi", "Delphi Prism (Oxygene)", "Diff", "DIV", "DOT", "E", "Easytrieve", "ECMAScript", "Eiffel", "Email", "EPC", "Erlang", "Euphoria", "F#", "Falcon", "Filemaker", "FO Language", "Formula One", "Fortran", "FreeBasic", "FreeSWITCH", "GAMBAS", "Game Maker", "GDB", "Genero", "Genie", "GetText", "Go", "Groovy", "GwBasic", "Haskell", "Haxe", "HicEst", "HQ9 Plus", "HTML", "HTML 5", "Icon", "IDL", "INI file", "Inno Script", "INTERCAL", "IO", "ISPF Panel Definition", "J", "Java", "Java 5", "JavaScript", "JCL", "jQuery", "JSON", "Julia", "KiXtart", "Latex", "LDIF", "Liberty BASIC", "Linden Scripting", "Lisp", "LLVM", "Loco Basic", "Logtalk", "LOL Code", "Lotus Formulas", "Lotus Script", "LScript", "Lua", "M68000 Assembler", "MagikSF", "Make", "MapBasic", "Markdown", "MatLab", "mIRC", "MIX Assembler", "Modula 2", "Modula 3", "Motorola 68000 HiSoft Dev", "MPASM", "MXML", "MySQL", "Nagios", "NetRexx", "newLISP", "Nginx", "Nimrod", "None", "NullSoft Installer", "Oberon 2", "Objeck Programming Langua", "Objective C", "OCalm Brief", "OCaml", "Octave", "Open Object Rexx", "OpenBSD PACKET FILTER", "OpenGL Shading", "Openoffice BASIC", "Oracle 11", "Oracle 8", "Oz", "ParaSail", "PARI/GP", "Pascal", "Pawn", "PCRE", "Per", "Perl", "Perl 6", "PHP", "PHP Brief", "Pic 16", "Pike", "Pixel Bender", "PL/I", "PL/SQL", "PostgreSQL", "PostScript", "POV-Ray", "Power Shell", "PowerBuilder", "ProFTPd", "Progress", "Prolog", "Properties", "ProvideX", "Puppet", "PureBasic", "PyCon", "Python", "Python for S60", "q/kdb+", "QBasic", "QML", "R", "Racket", "Rails", "RBScript", "REBOL", "REG", "Rexx", "Robots", "RPM Spec", "Ruby", "Ruby Gnuplot", "Rust", "SAS", "Scala", "Scheme", "Scilab", "SCL", "SdlBasic", "Smalltalk", "Smarty", "SPARK", "SPARQL", "SQF", "SQL", "StandardML", "StoneScript", "SuperCollider", "Swift", "SystemVerilog", "T-SQL", "TCL", "Tera Term", "thinBasic", "TypoScript", "Unicon", "UnrealScript", "UPC", "Urbi", "Vala", "VB.NET", "VBScript", "Vedit", "VeriLog", "VHDL", "VIM", "Visual Pro Log", "VisualBasic", "VisualFoxPro", "WhiteSpace", "WHOIS", "Winbatch", "XBasic", "XML", "Xorg Config", "XPP", "YAML", "Z80 Assembler", "ZXBasic"]
    
//    var languages: [String: String] = ["Java": "java", "Swift": "swift", "JavaScript": "javascript", "c#": "nil"]
    
//    var highlightrLanguages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Don't judge for the following code - fairly redudant but works
        let tapOutTextField: UITapGestureRecognizer = UITapGestureRecognizer(target: textView, action: #selector(edit));
        textView.delegate = self;
        textView.addGestureRecognizer(tapOutTextField);
        view.addGestureRecognizer(tapOutTextField)
        
        // Load previous pastes to savedList array
        loadSavedListItems()
        
        // Sets the theme of syntax highlighter. Could be made a choice in the future in Options menu.
        highlightr?.setTheme(to: "github-gist")
        
        // Picks up the default syntax/language that was set in options menu/view
        let defaults = UserDefaults.standard
        syntaxLanguage = languages[defaults.integer(forKey: "selectedText")]
        
//        highlightrLanguages = (highlightr?.supportedLanguages())!
//        print(highlightrLanguages)
        
    }
    
    @IBOutlet weak var titleText: UITextField!

    
    @IBAction func editAction(_ sender: Any) {
        titleText.text = "";
    }
    @IBOutlet weak var submitButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBAction func done(_ sender: Any) {
        if(!isCurrentlyEditing){
            if(textView.text?.isEmpty)!{
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil);
                let vC : ViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainView") as! ViewController;
                self.present(vC, animated: false, completion: nil);
            }else{
                let alertController = UIAlertController(title: "Are you sure?", message: "You'll lose all text currently in the editor", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil);
                    let vC : ViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainView") as! ViewController;
                    self.present(vC, animated: false, completion: nil);                }
                alertController.addAction(OKAction)
                let NoActions = UIAlertAction(title: "Cancel", style: .default) { (action) in
                    
                }
                alertController.addAction(NoActions)
                
                self.present(alertController, animated: true){
                    
                }
            }
            
        }else{
            isCurrentlyEditing = false;
            doneButton.title = "Back";
            view.endEditing(true);
            submitButtonState = true;
            submitButton.title = "Submit";
            
            // Converts pasted/typed text into highlighted syntax if selected in options menu
            let defaults = UserDefaults.standard
            
            if (defaults.object(forKey: "SyntaxState") != nil) {
                if defaults.bool(forKey: "SyntaxState") == true {
                    let code = textView.text
                    textView.attributedText = highlightr?.highlight(code!, as: syntaxLanguage)
//                    textView.attributedText = highlightr?.highlight(code!, as: syntaxLanguageHighlightr)
                }
            }
        }
    }
    @objc func edit(){
        isCurrentlyEditing = true
        submitButtonState = false
        submitButton.title = syntaxLanguage
        
        doneButton.title = "Done"
        
    }
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func submit(_ sender: Any) {
        if submitButtonState {
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
                    if(titleText.text?.isEmpty)!{
                        api_paste_name += "Created with Pastebin App";
                    }else{
                        api_paste_name += titleText.text!;
                    }
                    
                    let api_paste_expire_date = "&api_paste_expire_date=" + "N";
                    
                    var api_paste_format = "&api_paste_format=";
                    
                    if (defaults.object(forKey: "selectedText") != nil) {
                        api_paste_format += languages[defaults.integer(forKey: "selectedText")]
                    }else{
                        api_paste_format += "text";
                    }
                    
                    
                    let api_user_key = "&api_user_key=" + ""; // if an invalid api_user_key or no key is used, the paste will be create as a guest
                    let encoded_text = "&api_paste_code=" + (text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!;
                    
                    let encoded_title = api_paste_name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed);
                    
                    
                    var request = URLRequest(url: URL(string: "https://pastebin.com/api/api_post.php")!)
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
                            self.present(alertController, animated: true){
                                
                            }
                        }
                        
                        let responseString = String(data: data, encoding: .utf8)
                        UIPasteboard.general.string = responseString;
                        
                        // Adding the link to the savedList array and then saving to drive
                        self.savedList.append(responseString!)
                        self.saveSavedListItems()
                        
                        let alertController = UIAlertController(title: "Success!", message: responseString! + "\nSuccessfully copied to clipboard!", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            // handle response here.
                            self.textView.text = responseString;
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
        } else {
            // Pops up syntax selector popup if in Editing State
            selectSyntax()
        }
    }
    
    // Syntax picker method with segue via code
    func selectSyntax() {
        
        let sb = UIStoryboard(name: "SyntaxSelectViewController", bundle: nil)
        let popup = sb.instantiateInitialViewController()! as! SyntaxSelectViewController
        present(popup, animated: true)
        
        // Callback closure to fetch data from popup
        popup.onSave = { (data) in
            self.syntaxLanguage = data
            self.syntaxLanguageHighlightr = data
            self.submitButton.title = data
        }
        
    }
    
    // Save and load file/items/list methodologies...
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        
        return documentsDirectory().appendingPathComponent("SavedList.plist")
        
    }
    
    func saveSavedListItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(savedList)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array!")
        }
    }
    
    func loadSavedListItems() {
        
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                savedList = try decoder.decode([String].self, from: data)
            } catch {
                print("Error decoding item array!")
            }
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
        isCurrentlyEditing = true
        submitButtonState = false
        submitButton.title = syntaxLanguage
        
        doneButton.title = "Done"
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    
    //credit to http://stackoverflow.com/questions/39558868/check-internet-connection-ios-10
    //Simple check if internet is available
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
