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
        savedList = PastebinHelper().loadSavedListItems()
        savedList = savedList.reversed()

    }

    @IBAction func donePress(_ sender: Any) {

        // Transition to main view in order to reset background scrolling
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let vC: ViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainView") as! ViewController;
        self.present(vC, animated: true, completion: nil)

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

            // Alert pop-up copied from PastebinHelper.swift
            let alertController = UIAlertController(title: "", message: "Share link or copy to clipboard?", preferredStyle: .alert)
            let shareAction = UIAlertAction(title: "Share", style: .default) { (action) in
                
                let itemURL = URL(string: item) // NSURL(string: item)
                let vc = UIActivityViewController(activityItems: [itemURL ?? "No link found", item], applicationActivities: [])
                UIApplication.topViewController()?.present(vc, animated: true)
                print("responseString to share = \(String(describing: item))")
                
            }
            let copyAction = UIAlertAction(title: "Copy", style: .default, handler: { (action) in
                UIPasteboard.general.string = item
                print("responseString to copy = \(String(describing: item))")
            })
            
            alertController.addAction(shareAction)
            alertController.addAction(copyAction)
            self.present(alertController, animated: true) {
                
            }

            tableView.deselectRow(at: indexPath, animated: true) // to stop greying persisting

        }
    }

}
