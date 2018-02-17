//
//  photoFolderTableViewController.swift
//  PandaWeather
//
//  Created by Robin Allemand on 2/4/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

enum weatherConditions {
    case nice
    case cloudy
    case cold
    case rain
    case lightning
    case snow
    
    static let allValues = [nice, cloudy, cold, rain, lightning, snow]
}

var weatherFolders = ["Nice", "Cloudy", "Cold", "Rain", "Lightning", "Snow"]
var myIndex = 0

//protocol photoFolderTableViewControllerDelegate {
//    func didClose(controller: photoFolderTableViewController)
//}

class photoFolderTableViewController: UITableViewController {
//    var delegate: photoFolderTableViewControllerDelegate? = nil
//
//    @IBAction func closeButton(_ sender: UIBarButtonItem) {
//        self.delegate?.didClose(controller: self)
//    }
    
    @IBAction func infoButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Customize Background Weather Images", message: "Here's how to make your own pet images appear on the weather app: \n \n 1. Click on a weather folder. \n \n 2. Add an image. The app will create a local folder with your images. If the photo doesn't show up the first time, just click back to settings and go into the folder again. \n \n 3. If you want to remove a photo, just click 'Edit' in the folder and tap the 'x' on the photo. \n \n That's it! You'll see a random image of your pet whenever you reload your weather =)", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherConditions.allValues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = weatherFolders[indexPath.row]
        
        let imageName = UIImage(named: weatherFolders[indexPath.row] )
        cell.imageView?.image = imageName
        
        return cell
    }
    
    
    //share - take the user to the URL that is my app
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
        
        if indexPath.row == 0 {
            segueToPhotoFolder(.nice)
        }
            
        else if indexPath.row == 1 {
            segueToPhotoFolder(.cloudy)
        }
            
        else if indexPath.row == 2 {
            segueToPhotoFolder(.cold)
        }
            
        else if indexPath.row == 3 {
            segueToPhotoFolder(.rain)
        }
            
        else if indexPath.row == 4 {
            segueToPhotoFolder(.lightning)
        }
        
        else if indexPath.row == 5 {
            segueToPhotoFolder(.snow)
        }
        
        //        myIndex = indexPath.row
        //        performSegue(withIdentifier: "collectionVC", sender: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func segueToPhotoFolder(_ weatherConditions: weatherConditions) {
        switch weatherConditions {
        case .nice:
            return self.performSegue(withIdentifier: "showNice", sender: nil)
        case .cloudy:
            return self.performSegue(withIdentifier: "showCloudy", sender: nil)
        case .cold:
            return self.performSegue(withIdentifier: "showCold", sender: nil)
        case .rain:
            return self.performSegue(withIdentifier: "showRain", sender: nil)
        case .lightning:
            return self.performSegue(withIdentifier: "showLightning", sender: nil)
        case .snow:
            return self.performSegue(withIdentifier: "showSnow", sender: nil)
        }
    }
}

