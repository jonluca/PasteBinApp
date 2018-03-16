//
//  PreviousPastesViewController.swift
//  PasteBin
//
//  Created by Henrik Gustavii on 14/03/2018.
//  Copyright © 2018 JonLuca De Caro. All rights reserved.
//

import UIKit

class PreviousPastesViewController: UITableViewController {

    // Previous pastes array
    var savedList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load previous pastes to savedList array
        loadSavedListItems()
    }
    
    @IBAction func donePress(_ sender: Any) {
        self.dismiss(animated: true) {}
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousPasteCell", for: indexPath)
        
        cell.textLabel?.text = savedList[indexPath.item]
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            // let item = savedList[indexPath.row]
            
        }
    }
    
    // Load file/items/list methodologies...
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        
        return documentsDirectory().appendingPathComponent("SavedList.plist")
        
    }
    
//    func saveSavedListItems() {
//
//        let encoder = PropertyListEncoder()
//
//        do {
//            let data = try encoder.encode(savedList)
//            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
//        } catch {
//            print("Error encoding item array!")
//        }
//    }
    
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
    
}
