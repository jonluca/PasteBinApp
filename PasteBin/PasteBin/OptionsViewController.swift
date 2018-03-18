//
//  OptionsViewController.swift
//  PasteBin
//
//  Created by JonLuca De Caro on 12/29/16.
//  Copyright © 2016 JonLuca De Caro. All rights reserved.
//

import UIKit

class OptionsViewController: UITableViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    let languages = ["4CS", "6502 ACME Cross Assembler", "6502 Kick Assembler", "6502 TASM/64TASS", "ABAP", "ActionScript", "ActionScript 3", "Ada", "AIMMS", "ALGOL 68", "Apache Log", "AppleScript", "APT Sources", "ARM", "ASM (NASM)", "ASP", "Asymptote", "autoconf", "Autohotkey", "AutoIt", "Avisynth", "Awk", "BASCOM AVR", "Bash", "Basic4GL", "Batch", "BibTeX", "Blitz Basic", "Blitz3D", "BlitzMax", "BNF", "BOO", "BrainFuck", "C", "C (WinAPI)", "C for Macs", "C Intermediate Language", "C#", "C++", "C++ (WinAPI)", "C++ (with Qt extensions)", "C: Loadrunner", "CAD DCL", "CAD Lisp", "CFDG", "ChaiScript", "Chapel", "Clojure", "Clone C", "Clone C++", "CMake", "COBOL", "CoffeeScript", "ColdFusion", "CSS", "Cuesheet", "D", "Dart", "DCL", "DCPU-16", "DCS", "Delphi", "Delphi Prism (Oxygene)", "Diff", "DIV", "DOT", "E", "Easytrieve", "ECMAScript", "Eiffel", "Email", "EPC", "Erlang", "Euphoria", "F#", "Falcon", "Filemaker", "FO Language", "Formula One", "Fortran", "FreeBasic", "FreeSWITCH", "GAMBAS", "Game Maker", "GDB", "Genero", "Genie", "GetText", "Go", "Groovy", "GwBasic", "Haskell", "Haxe", "HicEst", "HQ9 Plus", "HTML", "HTML 5", "Icon", "IDL", "INI file", "Inno Script", "INTERCAL", "IO", "ISPF Panel Definition", "J", "Java", "Java 5", "JavaScript", "JCL", "jQuery", "JSON", "Julia", "KiXtart", "Latex", "LDIF", "Liberty BASIC", "Linden Scripting", "Lisp", "LLVM", "Loco Basic", "Logtalk", "LOL Code", "Lotus Formulas", "Lotus Script", "LScript", "Lua", "M68000 Assembler", "MagikSF", "Make", "MapBasic", "Markdown", "MatLab", "mIRC", "MIX Assembler", "Modula 2", "Modula 3", "Motorola 68000 HiSoft Dev", "MPASM", "MXML", "MySQL", "Nagios", "NetRexx", "newLISP", "Nginx", "Nimrod", "None", "NullSoft Installer", "Oberon 2", "Objeck Programming Langua", "Objective C", "OCalm Brief", "OCaml", "Octave", "Open Object Rexx", "OpenBSD PACKET FILTER", "OpenGL Shading", "Openoffice BASIC", "Oracle 11", "Oracle 8", "Oz", "ParaSail", "PARI/GP", "Pascal", "Pawn", "PCRE", "Per", "Perl", "Perl 6", "PHP", "PHP Brief", "Pic 16", "Pike", "Pixel Bender", "PL/I", "PL/SQL", "PostgreSQL", "PostScript", "POV-Ray", "Power Shell", "PowerBuilder", "ProFTPd", "Progress", "Prolog", "Properties", "ProvideX", "Puppet", "PureBasic", "PyCon", "Python", "Python for S60", "q/kdb+", "QBasic", "QML", "R", "Racket", "Rails", "RBScript", "REBOL", "REG", "Rexx", "Robots", "RPM Spec", "Ruby", "Ruby Gnuplot", "Rust", "SAS", "Scala", "Scheme", "Scilab", "SCL", "SdlBasic", "Smalltalk", "Smarty", "SPARK", "SPARQL", "SQF", "SQL", "StandardML", "StoneScript", "SuperCollider", "Swift", "SystemVerilog", "T-SQL", "TCL", "Tera Term", "thinBasic", "TypoScript", "Unicon", "UnrealScript", "UPC", "Urbi", "Vala", "VB.NET", "VBScript", "Vedit", "VeriLog", "VHDL", "VIM", "Visual Pro Log", "VisualBasic", "VisualFoxPro", "WhiteSpace", "WHOIS", "Winbatch", "XBasic", "XML", "Xorg Config", "XPP", "YAML", "Z80 Assembler", "ZXBasic"];
    
    @IBAction func save(_ sender: Any) {
        let defaults = UserDefaults.standard
        if unlistedSwitch.isOn {
            defaults.set(true, forKey: "SwitchState")
        } else {
            defaults.set(false, forKey: "SwitchState")
        }
        if(quickPasteTitle.text != nil){
            defaults.set(quickPasteTitle.text, forKey: "quickPasteTitle");
        }
        
        if syntaxSwitch.isOn {
            defaults.set(true, forKey: "SyntaxState")
        } else {
            defaults.set(false, forKey: "SyntaxState")
        }
        if(quickPasteTitle.text != nil){
            defaults.set(quickPasteTitle.text, forKey: "quickPasteTitle");
        }
        
        self.dismiss(animated: true, completion: {});
    }
    @IBOutlet weak var unlistedSwitch: UISwitch!
    @IBOutlet weak var syntaxSwitch: UISwitch!
    
    @IBOutlet weak var quickPasteTitle: UITextField!
    @IBAction func unlistedChange(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if unlistedSwitch.isOn {
            defaults.set(true, forKey: "SwitchState")
        } else {
            defaults.set(false, forKey: "SwitchState")
        }
    }
    
    @IBAction func syntaxChange(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if syntaxSwitch.isOn {
            defaults.set(true, forKey: "SyntaxState")
        } else {
            defaults.set(false, forKey: "SyntaxState")
        }
    }
    
    //Twitter
    @IBAction func twitterHandle(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://www.twitter.com/jonlucadecaro")!, options: [:], completionHandler: nil);
    }
    //Donate
    @IBAction func donate(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=TV28RGXB52DUA")!, options: [:], completionHandler: nil)
    }
    //Pastebin
    @IBAction func pastebin(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://www.pastebin.com")!, options: [:], completionHandler: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let defaults = UserDefaults.standard
        //Set Unlisted
        if (defaults.object(forKey: "SwitchState") != nil) {
            unlistedSwitch.isOn = defaults.bool(forKey: "SwitchState")
        }
        //Set language
        if (defaults.object(forKey: "selectedText") != nil) {
            textLabel.text = languages[defaults.integer(forKey: "selectedText")]
        }else{
            textLabel.text = "None";
            defaults.set(145, forKey: "selectedText");
        }
        //Set Syntax highlighter
        if (defaults.object(forKey: "SyntaxState") != nil) {
            syntaxSwitch.isOn = defaults.bool(forKey: "SyntaxState")
        }
        //Set quickpaste title
        if(quickPasteTitle.text != nil){
            quickPasteTitle.text = defaults.string(forKey: "quickPasteTitle");
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        let defaults = UserDefaults.standard
        
        if (defaults.object(forKey: "SwitchState") != nil) {
            unlistedSwitch.isOn = defaults.bool(forKey: "SwitchState")
        }
        //Populates text before it shows, to prevent animation lags
        if (defaults.object(forKey: "selectedText") != nil) {
            textLabel.text = languages[defaults.integer(forKey: "selectedText")]
        }else{
            textLabel.text = "None";
            defaults.set(145, forKey: "selectedText");
        }
        if (defaults.object(forKey: "SyntaxState") != nil) {
            syntaxSwitch.isOn = defaults.bool(forKey: "SyntaxState")
        }
    }
}
