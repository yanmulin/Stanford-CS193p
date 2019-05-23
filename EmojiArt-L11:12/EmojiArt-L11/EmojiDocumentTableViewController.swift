//
//  EmojiDocumentTableViewController.swift
//  EmojiArt-L11
//
//  Created by 颜木林 on 2019/5/17.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

class EmojiDocumentTableViewController: UITableViewController {
    
    var emojiDocuments = ["One", "Two", "Three"]
    
    
    @IBAction func addEmojiDocument(_ sender: Any) {
        emojiDocuments.append("untitled".makeUnique(emojiDocuments))
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojiDocuments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = emojiDocuments[indexPath.row]

        return cell
    }
    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            emojiDocuments.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}

extension String {
    func makeUnique(_ strings: [String]) ->String {
        if !strings.contains(self) {
            return self
        }
        
        var num = 1
        while (strings.contains(self + " \(num)")) {
            num += 1
        }
        return self + " \(num)"
    }
}
