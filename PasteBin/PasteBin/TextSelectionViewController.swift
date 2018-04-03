//
//  TextSelectionViewController.swift
//  PasteBin
//
//  Created by JonLuca De Caro on 1/9/17.
//  Copyright © 2017 JonLuca De Caro. All rights reserved.
//

import UIKit
import SearchTextField

class TextSelectionViewController: UITableViewController {

    //All available languages from the pastebin API
    let languages = ["4CS", "6502 ACME Cross Assembler", "6502 Kick Assembler", "6502 TASM/64TASS", "ABAP", "ActionScript", "ActionScript 3", "Ada", "AIMMS", "ALGOL 68", "Apache Log", "AppleScript", "APT Sources", "ARM", "ASM (NASM)", "ASP", "Asymptote", "autoconf", "Autohotkey", "AutoIt", "Avisynth", "Awk", "BASCOM AVR", "Bash", "Basic4GL", "Batch", "BibTeX", "Blitz Basic", "Blitz3D", "BlitzMax", "BNF", "BOO", "BrainFuck", "C", "C (WinAPI)", "C for Macs", "C Intermediate Language", "C#", "C++", "C++ (WinAPI)", "C++ (with Qt extensions)", "C: Loadrunner", "CAD DCL", "CAD Lisp", "CFDG", "ChaiScript", "Chapel", "Clojure", "Clone C", "Clone C++", "CMake", "COBOL", "CoffeeScript", "ColdFusion", "CSS", "Cuesheet", "D", "Dart", "DCL", "DCPU-16", "DCS", "Delphi", "Delphi Prism (Oxygene)", "Diff", "DIV", "DOT", "E", "Easytrieve", "ECMAScript", "Eiffel", "Email", "EPC", "Erlang", "Euphoria", "F#", "Falcon", "Filemaker", "FO Language", "Formula One", "Fortran", "FreeBasic", "FreeSWITCH", "GAMBAS", "Game Maker", "GDB", "Genero", "Genie", "GetText", "Go", "Groovy", "GwBasic", "Haskell", "Haxe", "HicEst", "HQ9 Plus", "HTML", "HTML 5", "Icon", "IDL", "INI file", "Inno Script", "INTERCAL", "IO", "ISPF Panel Definition", "J", "Java", "Java 5", "JavaScript", "JCL", "jQuery", "JSON", "Julia", "KiXtart", "Latex", "LDIF", "Liberty BASIC", "Linden Scripting", "Lisp", "LLVM", "Loco Basic", "Logtalk", "LOL Code", "Lotus Formulas", "Lotus Script", "LScript", "Lua", "M68000 Assembler", "MagikSF", "Make", "MapBasic", "Markdown", "MatLab", "mIRC", "MIX Assembler", "Modula 2", "Modula 3", "Motorola 68000 HiSoft Dev", "MPASM", "MXML", "MySQL", "Nagios", "NetRexx", "newLISP", "Nginx", "Nimrod", "None", "NullSoft Installer", "Oberon 2", "Objeck Programming Langua", "Objective C", "OCalm Brief", "OCaml", "Octave", "Open Object Rexx", "OpenBSD PACKET FILTER", "OpenGL Shading", "Openoffice BASIC", "Oracle 11", "Oracle 8", "Oz", "ParaSail", "PARI/GP", "Pascal", "Pawn", "PCRE", "Per", "Perl", "Perl 6", "PHP", "PHP Brief", "Pic 16", "Pike", "Pixel Bender", "PL/I", "PL/SQL", "PostgreSQL", "PostScript", "POV-Ray", "Power Shell", "PowerBuilder", "ProFTPd", "Progress", "Prolog", "Properties", "ProvideX", "Puppet", "PureBasic", "PyCon", "Python", "Python for S60", "q/kdb+", "QBasic", "QML", "R", "Racket", "Rails", "RBScript", "REBOL", "REG", "Rexx", "Robots", "RPM Spec", "Ruby", "Ruby Gnuplot", "Rust", "SAS", "Scala", "Scheme", "Scilab", "SCL", "SdlBasic", "Smalltalk", "Smarty", "SPARK", "SPARQL", "SQF", "SQL", "StandardML", "StoneScript", "SuperCollider", "Swift", "SystemVerilog", "T-SQL", "TCL", "Tera Term", "thinBasic", "TypoScript", "Unicon", "UnrealScript", "UPC", "Urbi", "Vala", "VB.NET", "VBScript", "Vedit", "VeriLog", "VHDL", "VIM", "Visual Pro Log", "VisualBasic", "VisualFoxPro", "WhiteSpace", "WHOIS", "Winbatch", "XBasic", "XML", "Xorg Config", "XPP", "YAML", "Z80 Assembler", "ZXBasic"];

    var syntaxIndex: Int = 0
    var syntax = ""
    
    @IBOutlet weak var searchSyntaxTextField: SearchTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Picks up the user default syntax/language
        let defaults = UserDefaults.standard
        syntaxIndex = defaults.integer(forKey: "selectedText")
        syntax = languages[defaults.integer(forKey: "selectedText")]
        
        let indexPath = IndexPath(row: self.syntaxIndex, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
        // SearchTextField settings
        searchSyntaxTextField.filterStrings(languages)

        // Handles what happens when user picks an item
        searchSyntaxTextField.itemSelectionHandler = { item, itemPosition in
            let item = item[itemPosition]
            self.searchSyntaxTextField.text = item.title
            self.syntax = item.title

            if self.languages.contains(self.syntax) {
                self.syntaxIndex = self.languages.index(of: self.syntax)!
                let indexPath = IndexPath(row: self.syntaxIndex, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }

    @IBAction func donePress(_ sender: Any) {
        self.dismiss(animated: true) {
        };
    }

    //251 Languages, for reference
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Select Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath as IndexPath);
        //Label it from languages and index
        cell.textLabel?.text = languages[indexPath.item];

        //Open savefile
        let defaults = UserDefaults.standard

        //If save already exists
        if (defaults.object(forKey: "selectedText") != nil) {
            if (indexPath.item == defaults.integer(forKey: "selectedText")) {
                cell.accessoryType = .checkmark;
            } else {
                cell.accessoryType = .none;
            }
        } else {
            let indPath = IndexPath(row: 145, section: 0)
            if let cell = tableView.cellForRow(at: indPath) {
                cell.accessoryType = .checkmark;
            }
        }
        return cell;
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Puts a checkmark on the selected one
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark;
        }
        //Bad Code Alert! I should be saving it as a local variable and then dynamically changing it/setting it to unchecked. But this gets around manual edits to the plist on jailbroken systems 😎
        for i in 0..<languages.count {
            if (i == indexPath.item) {
                continue;
            }
            let indPath = IndexPath(row: i, section: 0)
            if let cell = tableView.cellForRow(at: indPath) {
                cell.accessoryType = .none;
            }
        }

        //Saves the int of the selected languages item
        let defaults = UserDefaults.standard
        defaults.set(indexPath.item, forKey: "selectedText");
    }

    //Should deselect the selected one... But it only works after the initial selection, so hacky workaround above
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none;
        }
    }

}
