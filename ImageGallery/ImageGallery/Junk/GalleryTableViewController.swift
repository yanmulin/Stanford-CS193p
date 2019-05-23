//
//  GalleryTableViewController.swift
//  ImageGallert
//
//  Created by 颜木林 on 2019/5/20.
//  Copyright © 2019 yanmulin. All rights reserved.
//

import UIKit

class GalleryTableViewController: UITableViewController {
    
    var galleries = [ImageGallery]()
    var recentlyDelete = [ImageGallery]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        if navigationController?.splitViewController?.preferredDisplayMode != .primaryOverlay {
            navigationController?.splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }

    // MARK: - Table view data source / delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return recentlyDelete.count > 0 ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return galleries.count
        case 1: return recentlyDelete.count
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return nil
        case 1: return "Recently Delete"
        default: return nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "galleryCell", for: indexPath)
        
        if let cell = cell as? GalleryTableViewCell {
            switch indexPath.section {
            case 0:
                cell.cellText = galleries[indexPath.row].name
                cell.renameHandler = { [weak self] newName in
                    self?.galleries[indexPath.row].name = newName ?? ""
                    if let selectedIndexPath = self?.tableView.indexPathForSelectedRow, selectedIndexPath == indexPath {
                        if let cvc = (self?.navigationController?.splitViewController?.viewControllers.last as? UINavigationController)?.contents as? ImageGalleryCollectionViewController {
                            cvc.title = newName
                        }
                    }
                }
            case 1:
                cell.cellText = recentlyDelete[indexPath.row].name
                cell.renameHandler = { [weak self] newName in
                    self?.recentlyDelete[indexPath.row].name = newName ?? ""
                }
            default: break
            }
            
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let action = UIContextualAction(style: .normal, title: "Undelete") { [weak self] (_, _, completion) in
                self?.tableView.performBatchUpdates({
                    if let gallery = self?.recentlyDelete.remove(at: indexPath.row) {
                        self!.galleries.append(gallery)
                        tableView.insertRows(at: [IndexPath(row: self!.galleries.count - 1, section: 0)], with: .automatic)
                        if tableView.numberOfRows(inSection: 1) == 1 {
                            tableView.deleteSections(IndexSet([1]), with: .fade)
                        } else {
                            tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                        completion(true)
                    } else {
                        completion(false)
                    }
                }, completion: nil)
            }
            action.backgroundColor = UIColor.green
            return UISwipeActionsConfiguration(actions: [action])
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                tableView.performBatchUpdates({
                    let imageGallery = galleries.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    recentlyDelete.append(imageGallery)
                    if tableView.numberOfSections == 1 {
                        tableView.insertSections(IndexSet([1]), with: .automatic)
                    } else {
                        tableView.insertRows(at: [IndexPath(row: recentlyDelete.count - 1, section: 1)], with: .automatic)
                    }
                }, completion: nil)
            } else if indexPath.section == 1 {
                recentlyDelete.remove(at: indexPath.row)
                if tableView.numberOfRows(inSection: 1) == 1 {
                    tableView.deleteSections(IndexSet([1]), with: .fade)
                } else {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
    
    // MARK: actions
    @IBAction func add(_ sender: Any) {
        let imageGallery = ImageGallery("Untitled", [])
        galleries.append(imageGallery)
        tableView.insertRows(at: [IndexPath(row: galleries.count - 1, section: 0)], with: .automatic)
    }
    

    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showGallery" {
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPath(for: cell), indexPath.section > 0 {
                    return false
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGallery" {
            if let cvc = segue.destination.contents as? ImageGalleryCollectionViewController, let cell = sender as? UITableViewCell {
                if let row = tableView.indexPath(for: cell)?.row {
                    cvc.gallery = galleries[row]
                    cvc.title = galleries[row].name
                }
            }
        }
    }

}
