//
//  IAPConfirmViewController.swift
//  PandaWeather
//
//  Created by Robin Allemand on 6/19/20.
//  Copyright © 2020 Parse. All rights reserved.
//

import Foundation
import UIKit
import StoreKit
import SwiftyStoreKit

class IAPConfirmViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var enjoyLabel: UILabel!
    
    @IBAction func confirmButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "openPhotoFolderTVC", sender: nil)
    }
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        self.welcomeLabel.text! = "Welcome to your Weather Photo Plus Subscription!"
        self.enjoyLabel.text! = "Enjoy your Plus feature and benefits."
        
    }
    
    
}
