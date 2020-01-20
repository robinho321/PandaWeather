//
//  BookmarkTableViewController.swift
//  PandaWeather
//
//  Created by Robin Allemand on 1/18/20.
//  Copyright © 2020 Parse. All rights reserved.
//

import UIKit
import WebKit
import RealmSwift

class BookmarkTableViewController: UITableViewController {
    
    var bookmarks = [Bookmark]()
    var delegate: WeatherBrowserViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookmarks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Bookmark", for: indexPath) as! BookmarkTableViewCell
        
        let bookmark: Bookmark = bookmarks[indexPath.row]
        
        cell.title.text = bookmark.title
        cell.url.text = bookmark.url

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //delegate loads url from bookmarked indexpath
        delegate.loadWebSite(bookmarks[indexPath.row].url,true)
        navigationController?.popViewController(animated: true)
            
        }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let deletedBookmark: Bookmark = bookmarks.remove(at: indexPath.row)
            let realm = try! Realm()
            try! realm.write {
                realm.delete(deletedBookmark)
            }
            delegate.loadBookmarks()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
