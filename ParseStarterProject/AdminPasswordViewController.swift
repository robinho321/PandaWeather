//
//  AdminPasswordViewController.swift
//  PandaWeather
//
//  Created by Robin Allemand on 11/19/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import CoreData

class AdminPasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func confirmPassword(_ sender: UIButton) {
        if passwordTextField.text == "robinho" {
            self.performSegue(withIdentifier: "openAdminImageTable", sender: self)
        }
            else {
                    print("error")
                    let alert = UIAlertController(title: "Error", message: "Password Incorrect", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

//    @objc func loadAdminImageTableViewController(_ notification: Notification) {
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)//you need to set the storyboard id of your AdminImageTableViewController to "AdminImageTable"
//    let vc = storyboard.instantiateViewController(withIdentifier: "AdminImageTable")
//    present(vc, animated: true, completion: nil)
//}
}
