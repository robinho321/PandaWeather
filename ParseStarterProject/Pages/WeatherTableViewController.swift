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
            dayLabel.text! = day0[0] as! String
            
            let day1: NSArray = recoveredJsonDay!["startPeriodName"] as! NSArray
            print("\(day1[1])")
            dayLabelOne.text! = day1[1] as! String
            
            let day2: NSArray = recoveredJsonDay!["startPeriodName"] as! NSArray
            print("\(day2[2])")
            dayLabelTwo.text! = day2[2] as! String
            
            let day3: NSArray = recoveredJsonDay!["startPeriodName"] as! NSArray
            print("\(day3[3])")
            dayLabelThree.text! = day3[3] as! String
            
            let day4: NSArray = recoveredJsonDay!["startPeriodName"] as! NSArray
            print("\(day4[4])")
            dayLabelFour.text! = day4[4] as! String
            
            let day5: NSArray = recoveredJsonDay!["startPeriodName"] as! NSArray
            print("\(day5[5])")
            dayLabelFive.text! = day5[5] as! String
            
            let day6: NSArray = recoveredJsonDay!["startPeriodName"] as! NSArray
            print("\(day6[6])")
            dayLabelSix.text! = day6[6] as! String
            
            let day7: NSArray = recoveredJsonDay!["startPeriodName"] as! NSArray
            print("\(day7[7])")
            dayLabelSeven.text! = day7[7] as! String
            
            let day8: NSArray = recoveredJsonDay!["startPeriodName"] as! NSArray
            print("\(day8[8])")
            dayLabelEight.text! = day8[8] as! String
            
            let day9: NSArray = recoveredJsonDay!["startPeriodName"] as! NSArray
            print("\(day9[9])")
            dayLabelNine.text! = day9[9] as! String
            
            let day10: NSArray = recoveredJsonDay!["startPeriodName"] as! NSArray
            print("\(day10[10])")
            dayLabelTen.text! = day10[10] as! String
            
            let day11: NSArray = recoveredJsonDay!["startPeriodName"] as! NSArray
            print("\(day11[11])")
            dayLabelEleven.text! = day11[11] as! String

            let day12: NSArray = recoveredJsonDay!["startPeriodName"] as! NSArray
            print("\(day12[12])")
            dayLabelTwelve.text! = day12[12] as! String
            
        }
        
        //get the weather details to populate labels from userdefaults
        if recoveredJson!["text"] != nil {
            
            //Details weather details 0
            let weatherDescription0: NSArray = recoveredJson!["text"] as! NSArray
            print("\(weatherDescription0[0])")
            detailsLabel.text! = weatherDescription0[0] as! String
            
            let weatherDescription1: NSArray = recoveredJson!["text"] as! NSArray
            print("\(weatherDescription1[1])")
            detailsLabelOne.text! = weatherDescription1[1] as! String
            
            let weatherDescription2: NSArray = recoveredJson!["text"] as! NSArray
            print("\(weatherDescription2[2])")
            detailsLabelTwo.text! = weatherDescription2[2] as! String
            
            let weatherDescription3: NSArray = recoveredJson!["text"] as! NSArray
            print("\(weatherDescription3[3])")
            detailsLabelThree.text! = weatherDescription3[3] as! String
            
            let weatherDescription4: NSArray = recoveredJson!["text"] as! NSArray
            print("\(weatherDescription4[4])")
            detailsLabelFour.text! = weatherDescription4[4] as! String
            
            let weatherDescription5: NSArray = recoveredJson!["text"] as! NSArray
            print("\(weatherDescription5[5])")
            detailsLabelFive.text! = weatherDescription5[5] as! String
            
            let weatherDescription6: NSArray = recoveredJson!["text"] as! NSArray
            print("\(weatherDescription6[6])")
            detailsLabelSix.text! = weatherDescription6[6] as! String
            
            let weatherDescription7: NSArray = recoveredJson!["text"] as! NSArray
            print("\(weatherDescription7[7])")
            detailsLabelSeven.text! = weatherDescription7[7] as! String
            
            let weatherDescription8: NSArray = recoveredJson!["text"] as! NSArray
            print("\(weatherDescription8[8])")
            detailsLabelEight.text! = weatherDescription8[8] as! String
            
            let weatherDescription9: NSArray = recoveredJson!["text"] as! NSArray
            print("\(weatherDescription9[9])")
            detailsLabelNine.text! = weatherDescription9[9] as! String
            
            let weatherDescription10: NSArray = recoveredJson!["text"] as! NSArray
            print("\(weatherDescription10[10])")
            detailsLabelTen.text! = weatherDescription10[10] as! String

            let weatherDescription11: NSArray = recoveredJson!["text"] as! NSArray
            print("\(weatherDescription11[11])")
            detailsLabelEleven.text! = weatherDescription11[11] as! String

            let weatherDescription12: NSArray = recoveredJson!["text"] as! NSArray
            print("\(weatherDescription12[12])")
            detailsLabelTwelve.text! = weatherDescription12[12] as! String
        
    }
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
