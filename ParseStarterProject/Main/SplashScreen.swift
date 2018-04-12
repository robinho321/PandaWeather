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
            
            var pictureDate = ""
            
            let activityIndicator = UIActivityIndicatorView()

            //Spinner Activity indicator
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.startAnimating()
            
            self.view.addSubview(activityIndicator)
            
            //Fetch date and store in Core Data table
            var results = Date()!
            if results.count > 0 {
                let dates = results[0]
                
                pictureDate = ((dates as AnyObject).value(forKey: "pandaImageDate")as? String)!
                if ((dates as AnyObject).value(forKey: "pandaImageDate") == nil) {
                    pictureDate = ""
                } else {
                    pictureDate = ((dates as AnyObject).value(forKey: "pandaImageDate")as? String)!
                }
            } else {
                var error: NSError?
                var panda: SyncDate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext!
//                let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//                privateMOC.parent = managedContext
                let entity =  NSEntityDescription.entity(forEntityName: "SyncDate", in: managedContext)
                panda = (NSManagedObject(entity: entity!, insertInto:managedContext) as AnyObject) as! SyncDate
                panda.setValue("", forKey: "pandaImageDate")
                
                do {
                    try managedContext.save()
                    //Update Field
                } catch let error1 as NSError {
                    error = error1
                    print("Could not save \(String(describing: error)), \(String(describing: error?.userInfo))")
                }
            }
            
            //Call your core data fetch from PandaImages.swift
            PandaImagesCollect(pictureDate)

            NotificationCenter.default.addObserver(self, selector: #selector(SplashScreenViewController.loadMainViewController(_:)), name: NSNotification.Name(rawValue: "timesUpdated"), object: nil) //bookmark to call this function anywhere in code
        }
    
        @objc func loadMainViewController(_ notification: Notification) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)//you need to set the storyboard id of your original view for your app (Not the splash screen) to “"someViewController""
            let vc = storyboard.instantiateViewController(withIdentifier: "MainView")
            self.present(vc, animated: true, completion: nil)
            })
        }
    }

