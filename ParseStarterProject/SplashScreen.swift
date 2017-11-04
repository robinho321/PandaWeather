//
//  SplashScreen.swift
//  PandaWeather
//
//  Created by Robin Allemand on 11/2/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import MapKit
import UIKit

class SplashScreenViewController: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Spinner Activity indicator
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.startAnimating()

        self.view.addSubview(activityIndicator)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.performSegue(withIdentifier: "homeViewController", sender: self)
        
        self.activityIndicator.stopAnimating()
    }
}
