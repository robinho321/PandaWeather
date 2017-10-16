//
//  SettingsTableViewController.swift
//  Panda Weather
//
//  Created by Robin Allemand on 8/24/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import FacebookShare
import MessageUI
import QuartzCore

protocol SettingsTableViewControllerDelegate {
    func didClose(controller: SettingsTableViewController)
}

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    var delegate: SettingsTableViewControllerDelegate? = nil
    
    @IBOutlet weak var rateOnAppStoreLabel: UILabel!
    @IBOutlet weak var rateAppStoreIconImageView: UIImageView!
    @IBOutlet weak var shareFacebookLabel: UILabel!
    @IBOutlet weak var shareFacebookImageView: UIImageView!
    @IBOutlet weak var followInstagramLabel: UILabel!
    @IBOutlet weak var followInstagramImageView: UIImageView!
    @IBOutlet weak var contactUsLabel: UILabel!
    @IBOutlet weak var contactUsImageView: UIImageView!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var termsImageView: UIImageView!
    @IBAction func closeButton(_ sender: UIBarButtonItem) {

        self.delegate?.didClose(controller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rateOnAppStoreLabel.text! = "Rate on the App Store"
        rateAppStoreIconImageView.image! = #imageLiteral(resourceName: "appStore")
        
        shareFacebookLabel.text! = "Share via Facebook"
        shareFacebookImageView.image! = #imageLiteral(resourceName: "facebook")
        
        followInstagramLabel.text! = "Follow Pandapupgram"
        followInstagramImageView.image! = #imageLiteral(resourceName: "faceCute")
        
        contactUsLabel.text! = "Contact Us"
        contactUsImageView.image! = #imageLiteral(resourceName: "contactus")
        
        termsLabel.text! = "Terms and Conditions"
        termsImageView.image! = #imageLiteral(resourceName: "orangedot")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    //share - take the user to the URL that is my app
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    
        if indexPath.row == 0 {
    self.rateOnTheAppStore()
    }

    else if indexPath.row == 1 {
    self.shareViaFacebook()
    }

    else if indexPath.row == 2 {
    self.followPandaPupGram()
    }

    else if indexPath.row == 3 {
        self.contactUs()
    }
        
    else if indexPath.row == 4 {
    self.termsAndConditions()
    }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
     */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//            if segue.identifier == "closeSettings" {
//    }
    // }
 
    
    func rateOnTheAppStore() {
        let url = URL(string: "https://itunes.apple.com/us/app/panda-puppy-weather/id1281833307?ls=1&mt=8")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func shareViaFacebook() {
        let theUrl = URL(string: "https://itunes.apple.com/us/app/panda-puppy-weather/id1281833307?ls=1&mt=8")
        let content = LinkShareContent(url: theUrl!)
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .native
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            // Handle share results
        }
        
        try! shareDialog.show()
    }
        
    func followPandaPupGram() {
        let instaURL = URL(string: "http://www.instagram.com/pandapupgram")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(instaURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(instaURL)
        }
    }
    
    func termsAndConditions() {
        self.performSegue(withIdentifier: "showTerms", sender: nil)
    }
    
    func contactUs() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["pandapupgram@gmail.com"])
        composeVC.setSubject("Panda Weather Feedback")
        composeVC.setMessageBody("Hey Robin! Here's my feedback.", isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
        // User clicks Cancel
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
            // Check the result or perform other tasks.
            
            // Dismiss the mail compose view controller.
            controller.dismiss(animated: true, completion: nil)
        
        
        // User clicks Send
        
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
    }
}
