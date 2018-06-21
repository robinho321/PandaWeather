//
//  JsonRequest.swift
//  PandaWeather
//
//  Created by Robin Allemand on 6/17/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import Foundation
import UIKit

class JsonRequest {
    
    //FOR WEATHER RELOAD BUTTON
    func jsonWeatherRequest() {
        print("first")
        
        let location:CLLocationCoordinate2D = locationManager.location!.coordinate
        let lat = String(location.latitude)
        let long = String(location.longitude)
        let weatherURL = NSURL(string: "http://forecast.weather.gov/MapClick.php?lat=\(lat)&lon=\(long)&unit=0&lg=english&FcstType=json&TextType=1")
        let weatherData = try? Data(contentsOf: weatherURL! as URL)
        
        do {
            if let json = try JSONSerialization.jsonObject(with: weatherData!, options:.allowFragments) as? [String:Any] {
                print(json as Any)
                
                if json["currentobservation"] != nil {
                    
                    let currentObservation = json["currentobservation"] as! [String:Any]?
                    let temp: String = currentObservation?["Temp"] as! String
                    let tempDegreesF = temp + "℉"
                    temperatureLabel.text! = tempDegreesF
                    print("tempDegreesF: \(tempDegreesF)")
                    
                    let weatherCondition = json["currentobservation"] as! [String:Any]?
                    let condition: String = weatherCondition?["Weather"] as! String
                    conditionLabel.text! = condition
                    print("condition: \(condition)")
                    
                    let myLocation = json["location"] as! [String:Any]?
                    let city: String = myLocation?["areaDescription"] as! String
                    //                    let city = json["productionCenter"] as! String
                    cityLabel.text! = city
                    print("city: \(city)")
                    
                    let forecast = json["data"] as! [String:Any]?
                    let weatherDescription: NSArray = forecast!["text"] as! NSArray
                    print("\(weatherDescription[0])")
                    weatherLabel.text! = weatherDescription[0] as! String
                    
                    self.getUserImage(temperature: temp, condition: condition)
                    self.getWeatherIcon(theImageView: self.weatherImageView, theCondition: condition)
                    
                    //7-day forecast, day 1 Date, Weather Icon, and High/Low Temp
                    let sevenDayDate = json["time"] as! [String:Any]?
                    let sevenDayDateDescription: NSArray = sevenDayDate!["startPeriodName"] as! NSArray
                    print("\(sevenDayDateDescription[1])")
                    print("\(sevenDayDateDescription[12])")
                    
                    let dateCount = sevenDayDateDescription.count
                    print("dateCount: " + "\(dateCount)")
                    
                    // get the first three characters of the Date
                    let DayOne = String((sevenDayDateDescription[2] as! String).prefix(3))
                    print("\(DayOne)")
                    let DayTwo = String((sevenDayDateDescription[4] as! String).prefix(3))
                    let DayThree = String((sevenDayDateDescription[6] as! String).prefix(3))
                    let DayFour = String((sevenDayDateDescription[8] as! String).prefix(3))
                    let DayFive = String((sevenDayDateDescription[10] as! String).prefix(3))
                    print("\(DayFive)")
                    let DaySix = String((sevenDayDateDescription[12] as! String).prefix(3))
                    print("\(DaySix)")
                    print("\(dateCount)")
                    
                    if dateCount > 13 {
                        let DaySeven = String((sevenDayDateDescription[13] as! String).prefix(3))
                        print("Day Seven: " + "\(DaySeven)")
                        sevenDayDateLabel.text! = DayOne
                        sevenDayTwoDateLabel.text! = DayTwo
                        sevenDayThreeDateLabel.text! = DayThree
                        sevenDayFourDateLabel.text! = DayFour
                        sevenDayFiveDateLabel.text! = DayFive
                        sevenDaySixDateLabel.text! = DaySix
                        sevenDaySevenDateLabel.text! = DaySeven }
                        
                    else {
                        
                        if dateCount <= 13 {
                            sevenDayDateLabel.text! = DayOne
                            sevenDayTwoDateLabel.text! = DayTwo
                            sevenDayThreeDateLabel.text! = DayThree
                            sevenDayFourDateLabel.text! = DayFour
                            sevenDayFiveDateLabel.text! = DayFive
                            sevenDaySixDateLabel.text! = DaySix
                            sevenDaySevenDateLabel.text! = "NA" }
                    }
                    
                    let sevenDayTemp = json["data"] as! [String:Any]?
                    let sevenDayTempDescription: NSArray = sevenDayTemp!["temperature"] as! NSArray
                    print("\(sevenDayTempDescription[0], sevenDayTempDescription[1])")
                    
                    let tempCount = sevenDayTempDescription.count
                    print("tempCount: " + "\(tempCount)")
                    if tempCount > 13 {
                        sevenDayHighLowTempLabel.text! = "\(sevenDayTempDescription[1])" + " | " + "\(sevenDayTempDescription[2])"
                        sevenDayTwoHighLowTempLabel.text! = "\(sevenDayTempDescription[3])" + " | " + "\(sevenDayTempDescription[4])"
                        sevenDayThreeHighLowTempLabel.text! = "\(sevenDayTempDescription[5])" + " | " + "\(sevenDayTempDescription[6])"
                        sevenDayFourHighLowTempLabel.text! = "\(sevenDayTempDescription[7])" + " | " + "\(sevenDayTempDescription[8])"
                        sevenDayFiveHighLowTempLabel.text! = "\(sevenDayTempDescription[9])" + " | " + "\(sevenDayTempDescription[10])"
                        sevenDaySixHighLowTempLabel.text! = "\(sevenDayTempDescription[11])" + " | " + "\(sevenDayTempDescription[12])"
                        sevenDaySevenHighLowTempLabel.text! = "\(sevenDayTempDescription[12])" + " | " + "\(sevenDayTempDescription[13])"
                    }
                    
                    if tempCount <= 13 {
                        sevenDayHighLowTempLabel.text! = "\(sevenDayTempDescription[1])" + " | " + "\(sevenDayTempDescription[2])"
                        sevenDayTwoHighLowTempLabel.text! = "\(sevenDayTempDescription[3])" + " | " + "\(sevenDayTempDescription[4])"
                        sevenDayThreeHighLowTempLabel.text! = "\(sevenDayTempDescription[5])" + " | " + "\(sevenDayTempDescription[6])"
                        sevenDayFourHighLowTempLabel.text! = "\(sevenDayTempDescription[7])" + " | " + "\(sevenDayTempDescription[8])"
                        sevenDayFiveHighLowTempLabel.text! = "\(sevenDayTempDescription[9])" + " | " + "\(sevenDayTempDescription[10])"
                        sevenDaySixHighLowTempLabel.text! = "\(sevenDayTempDescription[11])" + " | " + "\(sevenDayTempDescription[12])"
                        sevenDaySevenHighLowTempLabel.text! = "\(sevenDayTempDescription[12])" + " | " + "NA"
                        
                    }
                    
                    //Setting the condition for input string in func getWeatherIcon and getUserImage
                    let sevenDayOneCondition = json["data"] as! [String:Any]?
                    let sevenDayConditionDescription: NSArray = sevenDayOneCondition!["weather"] as! NSArray
                    print("\(sevenDayConditionDescription[0])")
                    
                    let sevenDayOneConditionDescriptionZero: String = sevenDayConditionDescription[0] as! String
                    let sevenDayTwoConditionDescriptionOne: String = sevenDayConditionDescription[1] as! String
                    let sevenDayThreeConditionDescriptionTwo: String = sevenDayConditionDescription[2] as! String
                    let sevenDayFourConditionDescriptionThree: String = sevenDayConditionDescription[3] as! String
                    let sevenDayFiveConditionDescriptionFour: String = sevenDayConditionDescription[4] as! String
                    let sevenDaySixConditionDescriptionFive: String = sevenDayConditionDescription[5] as! String
                    let sevenDaySevenConditionDescriptionSix: String = sevenDayConditionDescription[6] as! String
                    
                    //                    self.getUserImage(temperature: sevenDayOneWeekTempZero, condition: sevenDayOneConditionDescriptionZero)
                    self.getWeatherIcon(theImageView: sevenDayWeatherImageView, theCondition: sevenDayOneConditionDescriptionZero)
                    
                    //                    self.getUserImage(temperature: sevenDayTwoWeekTempOne, condition: sevenDayTwoConditionDescriptionOne)
                    self.getWeatherIcon(theImageView: sevenDayTwoWeatherImageView, theCondition: sevenDayTwoConditionDescriptionOne)
                    
                    //                    self.getUserImage(temperature: sevenDayThreeWeekTempTwo, condition: sevenDayThreeConditionDescriptionTwo)
                    self.getWeatherIcon(theImageView: sevenDayThreeWeatherImageView, theCondition: sevenDayThreeConditionDescriptionTwo)
                    
                    //                    self.getUserImage(temperature: sevenDayFourWeekTempThree, condition: sevenDayFourConditionDescriptionThree)
                    self.getWeatherIcon(theImageView: sevenDayFourWeatherImageView, theCondition: sevenDayFourConditionDescriptionThree)
                    
                    //                    self.getUserImage(temperature: sevenDayFiveWeekTempFour, condition: sevenDayFiveConditionDescriptionFour)
                    self.getWeatherIcon(theImageView: sevenDayFiveWeatherImageView, theCondition: sevenDayFiveConditionDescriptionFour)
                    
                    //                    self.getUserImage(temperature: sevenDaySixWeekTempFive, condition: sevenDaySixConditionDescriptionFive)
                    self.getWeatherIcon(theImageView: sevenDaySixWeatherImageView, theCondition: sevenDaySixConditionDescriptionFive)
                    
                    //                    self.getUserImage(temperature: sevenDaySevenWeekTempSix, condition: sevenDaySevenConditionDescriptionSix)
                    self.getWeatherIcon(theImageView: sevenDaySevenWeatherImageView, theCondition: sevenDaySevenConditionDescriptionSix)
                }
                else{
                    print("error")
                    let alert = UIAlertController(title: "Error", message: "United States weather only, please try another location in the United States!", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } catch let err{
            print(err.localizedDescription)
        }
        //        self.getTemperatureActivityIndicator.stopAnimating()
        
    }
    
}
