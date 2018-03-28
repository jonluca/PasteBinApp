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

    var languages = ["4CS", "6502 ACME Cross Assembler", "6502 Kick Assembler", "6502 TASM/64TASS", "ABAP", "ActionScript", "ActionScript 3", "Ada", "AIMMS", "ALGOL 68", "Apache Log", "AppleScript", "APT Sources", "ARM", "ASM (NASM)", "ASP", "Asymptote", "autoconf", "Autohotkey", "AutoIt", "Avisynth", "Awk", "BASCOM AVR", "Bash", "Basic4GL", "Batch", "BibTeX", "Blitz Basic", "Blitz3D", "BlitzMax", "BNF", "BOO", "BrainFuck", "C", "C (WinAPI)", "C for Macs", "C Intermediate Language", "C#", "C++", "C++ (WinAPI)", "C++ (with Qt extensions)", "C: Loadrunner", "CAD DCL", "CAD Lisp", "CFDG", "ChaiScript", "Chapel", "Clojure", "Clone C", "Clone C++", "CMake", "COBOL", "CoffeeScript", "ColdFusion", "CSS", "Cuesheet", "D", "Dart", "DCL", "DCPU-16", "DCS", "Delphi", "Delphi Prism (Oxygene)", "Diff", "DIV", "DOT", "E", "Easytrieve", "ECMAScript", "Eiffel", "Email", "EPC", "Erlang", "Euphoria", "F#", "Falcon", "Filemaker", "FO Language", "Formula One", "Fortran", "FreeBasic", "FreeSWITCH", "GAMBAS", "Game Maker", "GDB", "Genero", "Genie", "GetText", "Go", "Groovy", "GwBasic", "Haskell", "Haxe", "HicEst", "HQ9 Plus", "HTML", "HTML 5", "Icon", "IDL", "INI file", "Inno Script", "INTERCAL", "IO", "ISPF Panel Definition", "J", "Java", "Java 5", "JavaScript", "JCL", "jQuery", "JSON", "Julia", "KiXtart", "Latex", "LDIF", "Liberty BASIC", "Linden Scripting", "Lisp", "LLVM", "Loco Basic", "Logtalk", "LOL Code", "Lotus Formulas", "Lotus Script", "LScript", "Lua", "M68000 Assembler", "MagikSF", "Make", "MapBasic", "Markdown", "MatLab", "mIRC", "MIX Assembler", "Modula 2", "Modula 3", "Motorola 68000 HiSoft Dev", "MPASM", "MXML", "MySQL", "Nagios", "NetRexx", "newLISP", "Nginx", "Nimrod", "None", "NullSoft Installer", "Oberon 2", "Objeck Programming Langua", "Objective C", "OCalm Brief", "OCaml", "Octave", "Open Object Rexx", "OpenBSD PACKET FILTER", "OpenGL Shading", "Openoffice BASIC", "Oracle 11", "Oracle 8", "Oz", "ParaSail", "PARI/GP", "Pascal", "Pawn", "PCRE", "Per", "Perl", "Perl 6", "PHP", "PHP Brief", "Pic 16", "Pike", "Pixel Bender", "PL/I", "PL/SQL", "PostgreSQL", "PostScript", "POV-Ray", "Power Shell", "PowerBuilder", "ProFTPd", "Progress", "Prolog", "Properties", "ProvideX", "Puppet", "PureBasic", "PyCon", "Python", "Python for S60", "q/kdb+", "QBasic", "QML", "R", "Racket", "Rails", "RBScript", "REBOL", "REG", "Rexx", "Robots", "RPM Spec", "Ruby", "Ruby Gnuplot", "Rust", "SAS", "Scala", "Scheme", "Scilab", "SCL", "SdlBasic", "Smalltalk", "Smarty", "SPARK", "SPARQL", "SQF", "SQL", "StandardML", "StoneScript", "SuperCollider", "Swift", "SystemVerilog", "T-SQL", "TCL", "Tera Term", "thinBasic", "TypoScript", "Unicon", "UnrealScript", "UPC", "Urbi", "Vala", "VB.NET", "VBScript", "Vedit", "VeriLog", "VHDL", "VIM", "Visual Pro Log", "VisualBasic", "VisualFoxPro", "WhiteSpace", "WHOIS", "Winbatch", "XBasic", "XML", "Xorg Config", "XPP", "YAML", "Z80 Assembler", "ZXBasic"]

    override func viewDidLoad() {
        super.viewDidLoad()
        //Don't judge for the following code - fairly redundant but works
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
        syntaxIndex = defaults.integer(forKey: "selectedText")
        syntaxPastebin = languages[defaults.integer(forKey: "selectedText")]
        syntaxHighlightr = langMap[syntaxPastebin]!

    }

    @IBOutlet weak var titleText: UITextField!


    @IBAction func editAction(_ sender: Any) {
        titleText.text = "";
    }

    @IBOutlet weak var submitButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!

    @IBAction func done(_ sender: Any) {
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
            isCurrentlyEditing = false;
            doneButton.title = "Back";
            view.endEditing(true);
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

    @objc func edit() {
        isCurrentlyEditing = true
        submitButtonState = false
        submitButton.title = syntaxPastebin

        doneButton.title = "Done"

    }

    @IBOutlet weak var textView: UITextView!

    @IBAction func submit(_ sender: Any) {
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
                if (isInternetAvailable()) {

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
                        api_paste_format += languages[defaults.integer(forKey: "selectedText")]
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
                        self.saveSavedListItems()

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
            // Pops up syntax selector popup if in Editing State
            selectSyntax()
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
            self.syntaxHighlightr = self.langMap[data]!
            self.syntaxIndex = index
            self.syntaxPastebin = data
            self.submitButton.title = self.syntaxPastebin
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
        submitButton.title = syntaxPastebin

        doneButton.title = "Done"
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        return true
    }


    //credit to http://stackoverflow.com/questions/39558868/check-internet-connection-ios-10
    //Simple check if internet is available
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
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

    let langMap = [
        "4CS": "default",
        "6502 ACME Cross Assembler": "default",
        "6502 Kick Assembler": "default",
        "6502 TASM/64TASS": "default",
        "ABAP": "default",
        "ActionScript": "actionscript",
        "ActionScript 3": "actionscript",
        "Ada": "ada",
        "AIMMS": "default",
        "ALGOL 68": "default",
        "Apache Log": "apache",
        "AppleScript": "applescript",
        "APT Sources": "default",
        "ARM": "armasm",
        "ASM (NASM)": "armasm",
        "ASP": "default",
        "Asymptote": "default",
        "autoconf": "default",
        "Autohotkey": "autohotkey",
        "AutoIt": "autoit",
        "Avisynth": "default",
        "Awk": "awk",
        "BASCOM AVR": "default",
        "Bash": "bash",
        "Basic4GL": "basic",
        "Batch": "default",
        "BibTeX": "default",
        "Blitz Basic": "basic",
        "Blitz3D": "default",
        "BlitzMax": "default",
        "BNF": "bnf",
        "BOO": "default",
        "BrainFuck": "brainfuck",
        "C": "cpp",
        "C (WinAPI)": "cpp",
        "C for Macs": "cpp",
        "C Intermediate Language": "cpp",
        "C#": "cpp",
        "C++": "cpp",
        "C++ (WinAPI)": "cpp",
        "C++ (with Qt extensions)": "cpp",
        "C: Loadrunner": "cpp",
        "CAD DCL": "default",
        "CAD Lisp": "lisp",
        "CFDG": "default",
        "ChaiScript": "default",
        "Chapel": "default",
        "Clojure": "clojure",
        "Clone C": "cpp",
        "Clone C++": "cpp",
        "CMake": "cmake",
        "COBOL": "default",
        "CoffeeScript": "coffeescript",
        "ColdFusion": "default",
        "CSS": "css",
        "Cuesheet": "default",
        "D": "d",
        "Dart": "dart",
        "DCL": "default",
        "DCPU-16": "default",
        "DCS": "default",
        "Delphi": "delphi",
        "Delphi Prism (Oxygene)": "delphi",
        "Diff": "diff",
        "DIV": "default",
        "DOT": "default",
        "E": "default",
        "Easytrieve": "default",
        "ECMAScript": "javascript",
        "Eiffel": "default",
        "Email": "default",
        "EPC": "default",
        "Erlang": "erlang",
        "Euphoria": "default",
        "F#": "fsharp",
        "Falcon": "default",
        "Filemaker": "default",
        "FO Language": "default",
        "Formula One": "default",
        "Fortran": "fortran",
        "FreeBasic": "default",
        "FreeSWITCH": "default",
        "GAMBAS": "default",
        "Game Maker": "default",
        "GDB": "default",
        "Genero": "default",
        "Genie": "default",
        "GetText": "default",
        "Go": "go",
        "Groovy": "groovy",
        "GwBasic": "default",
        "Haskell": "haskell",
        "Haxe": "haxe",
        "HicEst": "default",
        "HQ9 Plus": "default",
        "HTML": "htmlbars",
        "HTML 5": "htmlbars",
        "Icon": "default",
        "IDL": "default",
        "INI file": "ini",
        "Inno Script": "default",
        "INTERCAL": "default",
        "IO": "default",
        "ISPF Panel Definition": "default",
        "J": "default",
        "Java": "java",
        "Java 5": "java",
        "JavaScript": "javascript",
        "JCL": "default",
        "jQuery": "javascript",
        "JSON": "json",
        "Julia": "julia",
        "KiXtart": "default",
        "Latex": "default",
        "LDIF": "ldif",
        "Liberty BASIC": "basic",
        "Linden Scripting": "default",
        "Lisp": "lisp",
        "LLVM": "llvm",
        "Loco Basic": "basic",
        "Logtalk": "default",
        "LOL Code": "default",
        "Lotus Formulas": "default",
        "Lotus Script": "default",
        "LScript": "livescript",
        "Lua": "lua",
        "M68000 Assembler": "default",
        "MagikSF": "default",
        "Make": "makefile",
        "MapBasic": "default",
        "Markdown": "markdown",
        "MatLab": "matlab",
        "mIRC": "default",
        "MIX Assembler": "default",
        "Modula 2": "default",
        "Modula 3": "default",
        "Motorola 68000 HiSoft Dev": "default",
        "MPASM": "mipsasm",
        "MXML": "default",
        "MySQL": "sql",
        "Nagios": "default",
        "NetRexx": "default",
        "newLISP": "default",
        "Nginx": "nginx",
        "Nimrod": "nimrod",
        "None": "none",
        "NullSoft Installer": "default",
        "Oberon 2": "default",
        "Objeck Programming Langua": "default",
        "Objective C": "objectivec",
        "OCalm Brief": "ocaml",
        "OCaml": "ocaml",
        "Octave": "default",
        "Open Object Rexx": "default",
        "OpenBSD PACKET FILTER": "default",
        "OpenGL Shading": "default",
        "Openoffice BASIC": "default",
        "Oracle 11": "default",
        "Oracle 8": "default",
        "Oz": "default",
        "ParaSail": "default",
        "PARI/GP": "default",
        "Pascal": "default",
        "Pawn": "default",
        "PCRE": "default",
        "Per": "default",
        "Perl": "perl",
        "Perl 6": "perl",
        "PHP": "php",
        "PHP Brief": "php",
        "Pic 16": "default",
        "Pike": "default",
        "Pixel Bender": "default",
        "PL/I": "default",
        "PL/SQL": "default",
        "PostgreSQL": "default",
        "PostScript": "default",
        "POV-Ray": "default",
        "Power Shell": "powershell",
        "PowerBuilder": "default",
        "ProFTPd": "default",
        "Progress": "default",
        "Prolog": "prolog",
        "Properties": "default",
        "ProvideX": "default",
        "Puppet": "puppet",
        "PureBasic": "purebasic",
        "PyCon": "python",
        "Python": "python",
        "Python for S60": "python",
        "q/kdb+": "q",
        "QBasic": "default",
        "QML": "qml",
        "R": "r",
        "Racket": "default",
        "Rails": "ruby",
        "RBScript": "default",
        "REBOL": "default",
        "REG": "default",
        "Rexx": "default",
        "Robots": "default",
        "RPM Spec": "default",
        "Ruby": "ruby",
        "Ruby Gnuplot": "ruby",
        "Rust": "rust",
        "SAS": "default",
        "Scala": "scala",
        "Scheme": "scheme",
        "Scilab": "scilab",
        "SCL": "default",
        "SdlBasic": "default",
        "Smalltalk": "smalltalk",
        "Smarty": "default",
        "SPARK": "default",
        "SPARQL": "default",
        "SQF": "sqf",
        "SQL": "sql",
        "StandardML": "default",
        "StoneScript": "default",
        "SuperCollider": "default",
        "Swift": "swift",
        "SystemVerilog": "default",
        "T-SQL": "sql",
        "TCL": "tcl",
        "Tera Term": "default",
        "thinBasic": "default",
        "TypoScript": "default",
        "Unicon": "default",
        "UnrealScript": "default",
        "UPC": "default",
        "Urbi": "default",
        "Vala": "vala",
        "VB.NET": "vbnet",
        "VBScript": "vbscript",
        "Vedit": "default",
        "VeriLog": "verilog",
        "VHDL": "vhdl",
        "VIM": "vim",
        "Visual Pro Log": "default",
        "VisualBasic": "default",
        "VisualFoxPro": "default",
        "WhiteSpace": "default",
        "WHOIS": "default",
        "Winbatch": "default",
        "XBasic": "default",
        "XML": "xml",
        "Xorg Config": "default",
        "XPP": "default",
        "YAML": "yaml",
        "Z80 Assembler": "default",
        "ZXBasic": "default",
    ]

}
