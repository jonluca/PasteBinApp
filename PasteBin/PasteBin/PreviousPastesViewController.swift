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

        // Transition to main view in order to reset background scrolling
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let vC: ViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainView") as! ViewController;
        self.present(vC, animated: false, completion: nil)

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
        if tableView.cellForRow(at: indexPath) != nil {

            let item = savedList[indexPath.row]
            UIPasteboard.general.string = item

            // Alert pop-up borrowed from PasteView.swift
            let alertController = UIAlertController(title: "Success!", message: item + "\nSuccessfully copied to clipboard!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) {
            }

            tableView.deselectRow(at: indexPath, animated: true) // to stop greying persisting

        }
    }

    // Load file/items/list methodologies...
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        return paths[0]

    }

    func dataFilePath() -> URL {

        return documentsDirectory().appendingPathComponent("SavedList.plist")

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

}
