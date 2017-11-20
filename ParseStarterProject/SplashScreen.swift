//
//  SplashScreen.swift
//  PandaWeather
//
//  Created by Robin Allemand on 11/2/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import MapKit
import UIKit
import CoreData

class SplashScreenViewController: UIViewController {

        override func viewDidLoad() {
            super.viewDidLoad()
            
            let activityIndicator = UIActivityIndicatorView()

            //Spinner Activity indicator
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.startAnimating()
            
            self.view.addSubview(activityIndicator)
            
            //Call your core data fetch from PandaImages.swift
            PandaImagesCollect()
            NotificationCenter.default.addObserver(self, selector: #selector(SplashScreenViewController.loadMainViewController(_:)), name: NSNotification.Name(rawValue: "timesUpdated"), object: nil) //bookmark to call this function anywhere in code
            
        }
        
//        @objc func loadImage(_ notification: Notification) {
//            PandaImagesCollect()
//        }
    
        @objc func loadMainViewController(_ notification: Notification) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)//you need to set the storyboard id of your original view for your app (Not the splash screen) to “"someViewController""
            let vc = storyboard.instantiateViewController(withIdentifier: "MainView")
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        self.performSegue(withIdentifier: "homeViewController", sender: self)
//
//        self.activityIndicator.stopAnimating()
//    }
