//
//  WeatherTableViewController.swift
//  PandaWeather
//
//  Created by Robin Allemand on 6/16/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import Foundation
import UIKit
import FacebookShare
import MessageUI
import QuartzCore
import Photos

protocol WeatherTableViewControllerDelegate {
    func didCloseAgain(controller: WeatherTableViewController)
}

class WeatherTableViewController: UITableViewController {
    
    var delegate: WeatherTableViewControllerDelegate? = nil
    
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        self.delegate?.didCloseAgain(controller: self)
        }
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var dayLabelOne: UILabel!
    @IBOutlet weak var detailsLabelOne: UILabel!
    
    @IBOutlet weak var dayLabelTwo: UILabel!
    @IBOutlet weak var detailsLabelTwo: UILabel!
    
    @IBOutlet weak var dayLabelThree: UILabel!
    @IBOutlet weak var detailsLabelThree: UILabel!
    
    @IBOutlet weak var dayLabelFour: UILabel!
    @IBOutlet weak var detailsLabelFour: UILabel!
    
    @IBOutlet weak var dayLabelFive: UILabel!
    @IBOutlet weak var detailsLabelFive: UILabel!
    
    @IBOutlet weak var dayLabelSix: UILabel!
    @IBOutlet weak var detailsLabelSix: UILabel!
    
    @IBOutlet weak var dayLabelSeven: UILabel!
    @IBOutlet weak var detailsLabelSeven: UILabel!
    
    @IBOutlet weak var dayLabelEight: UILabel!
    @IBOutlet weak var detailsLabelEight: UILabel!
    
    @IBOutlet weak var dayLabelNine: UILabel!
    @IBOutlet weak var detailsLabelNine: UILabel!
    
    @IBOutlet weak var dayLabelTen: UILabel!
    @IBOutlet weak var detailsLabelTen: UILabel!
    
    @IBOutlet weak var dayLabelEleven: UILabel!
    @IBOutlet weak var detailsLabelEleven: UILabel!
    
    @IBOutlet weak var dayLabelTwelve: UILabel!
    @IBOutlet weak var detailsLabelTwelve: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getWeather()
        
    }
    
    func getWeather() {
        let defaults = UserDefaults()
        let recoveredJsonData = defaults.object(forKey: "data")
        let recoveredJson = NSKeyedUnarchiver.unarchiveObject(with: recoveredJsonData as! Data) as! [String:Any]?
        print("myData: \(String(describing: recoveredJson))")
        
        let recoveredJsonDataDay = defaults.object(forKey: "days")
        let recoveredJsonDay = NSKeyedUnarchiver.unarchiveObject(with: recoveredJsonDataDay as! Data) as! [String:Any]?
        print("myDays: \(String(describing: recoveredJsonDay))")
        
        //get the days to populate labels from userdefaults
        if recoveredJsonDay!["startPeriodName"] != nil {
            
            //day0
            let day0: NSArray = recoveredJsonDay!["startPeriodName"] as! NSArray
            print("\(day0[0])")
            
            //make the tableview background change if day0 is "nighttime" or "daytime"
            if [day0[0] as! String].contains("night") || [day0[0] as! String].contains("Tonight") || [day0[0] as! String].contains("Overnight") {
                tableView.tableFooterView = UIView(frame: CGRect.zero)
                let backgroundImage = UIImage(named: "nighttime")
                let imageView = UIImageView(image: backgroundImage)
                imageView.contentMode = .scaleAspectFill
                self.tableView.backgroundView = imageView
                detailsLabel.textColor = UIColor.white
                detailsLabelOne.textColor = UIColor.white
                detailsLabelTwo.textColor = UIColor.white
                detailsLabelThree.textColor = UIColor.white
                detailsLabelFour.textColor = UIColor.white
                detailsLabelFive.textColor = UIColor.white
                detailsLabelSix.textColor = UIColor.white
                detailsLabelSeven.textColor = UIColor.white
                detailsLabelEight.textColor = UIColor.white
                detailsLabelNine.textColor = UIColor.white
                detailsLabelTen.textColor = UIColor.white
                detailsLabelEleven.textColor = UIColor.white
                detailsLabelTwelve.textColor = UIColor.white
                
            
            } else {
                tableView.tableFooterView = UIView(frame: CGRect.zero)
                let backgroundImage = UIImage(named: "daytime")
                let imageView = UIImageView(image: backgroundImage)
                imageView.contentMode = .scaleAspectFill
                self.tableView.backgroundView = imageView
            }
            //continue...

            dayLabel.text! = day0[0] as! String
            dayLabelOne.text! = day0[1] as! String
            dayLabelTwo.text! = day0[2] as! String
            dayLabelThree.text! = day0[3] as! String
            dayLabelFour.text! = day0[4] as! String
            dayLabelFive.text! = day0[5] as! String
            dayLabelSix.text! = day0[6] as! String
            dayLabelSeven.text! = day0[7] as! String
            dayLabelEight.text! = day0[8] as! String
            dayLabelNine.text! = day0[9] as! String
            dayLabelTen.text! = day0[10] as! String
            dayLabelEleven.text! = day0[11] as! String
            dayLabelTwelve.text! = day0[12] as! String
            
        } else {
            let alert = UIAlertController(title: "No Weather Data Found", message: "Our weather service is currently experiencing issues. Please check back later. Thanks!", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        //get the weather details to populate labels from userdefaults
        if recoveredJson!["text"] != nil {
            
            //Details weather details 0
            let weatherDescription0: NSArray = recoveredJson!["text"] as! NSArray
            print("\(weatherDescription0[0])")
            
            detailsLabel.text! = weatherDescription0[0] as! String
            detailsLabelOne.text! = weatherDescription0[1] as! String
            detailsLabelTwo.text! = weatherDescription0[2] as! String
            detailsLabelThree.text! = weatherDescription0[3] as! String
            detailsLabelFour.text! = weatherDescription0[4] as! String
            detailsLabelFive.text! = weatherDescription0[5] as! String
            detailsLabelSix.text! = weatherDescription0[6] as! String
            detailsLabelSeven.text! = weatherDescription0[7] as! String
            detailsLabelEight.text! = weatherDescription0[8] as! String
            detailsLabelNine.text! = weatherDescription0[9] as! String
            detailsLabelTen.text! = weatherDescription0[10] as! String
            detailsLabelEleven.text! = weatherDescription0[11] as! String
            detailsLabelTwelve.text! = weatherDescription0[12] as! String
        
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.25)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
        
        if indexPath.row == 0 {
            
        }
        
        if indexPath.row == 1 {
            
        }
        
        if indexPath.row == 2 {
            
        }
        
        if indexPath.row == 3 {
            
        }
        
        if indexPath.row == 4 {
            
        }
        
        if indexPath.row == 5 {
            
        }
        
        if indexPath.row == 6 {
            
        }
    
    }
}
