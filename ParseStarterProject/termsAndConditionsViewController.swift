//
//  termsAndConditionsViewController.swift
//  Panda Weather
//
//  Created by Robin Allemand on 8/28/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import UIKit

class termsAndConditionsViewController: UIViewController {
    
    @IBOutlet weak var termsAndConditions: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Terms and Conditions"
    }
    
}
