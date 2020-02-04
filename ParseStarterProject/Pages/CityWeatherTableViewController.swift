//
//  CityWeatherTableViewController.swift
//  PandaWeather
//
//  Created by Robin Allemand on 1/25/20.
//  Copyright © 2020 Parse. All rights reserved.
//

import UIKit
import RealmSwift

protocol CityWeatherTableViewControllerDelegate {
    func didCloseOnceMoreAgainAgainAgain(controller: ViewController)
}

class CityWeatherTableViewController: UITableViewController, UISearchBarDelegate {
    
    var cities = [City]()
    var delegate: ViewController!
    
     override func viewDidLoad() {
            super.viewDidLoad()
            getWeather()
            loadCities()
            tableView.reloadData()
        }
    
        // MARK: - Table view data source

        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return cities.count
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "City", for: indexPath) as! CityTableViewCell
            
            let city: City = cities[indexPath.row]
            
            cell.city.text = city.city

            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //delegate loads weather from city indexpath
            if delegate.switchLabel.isOn {
                    delegate.forwardGeocodingUser(cities[indexPath.row].city)
                    delegate.getTemperatureActivityIndicator.startAnimating()
                } else {
                    delegate.forwardGeocodingPanda(cities[indexPath.row].city)
                    delegate.getTemperatureActivityIndicator.startAnimating()
                }
            
            self.delegate?.didCloseOnceMoreAgainAgainAgain(controller: self)
                
            }
    
        override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                       forRowAt indexPath: IndexPath) {
            
            cell.backgroundColor = UIColor(white: 1, alpha: 0.25)
            cell.textLabel?.textColor = .white
        }

        // Override to support conditional editing of the table view.
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }

        // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Delete the row from the data source
                let deletedCity: City = cities.remove(at: indexPath.row)
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(deletedCity)
                }
                loadCities()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
        }
    
    //Toolbar functions
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        self.delegate?.didCloseOnceMoreAgainAgainAgain(controller: self)
    }
    
    @IBAction func infoButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Favorite Cities", message: "Tap the '+' on the top right of the screen to add a city in the United States. The text you enter in the search bar will be saved to your list. \n \n When you tap the saved city, the main view will be updated with that city's weather information. \n \n Delete cities from your list by swiping right. \n \n Reminder: NOAA weather data is for **USA only**.", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addCityButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
            searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            //Hide search bar
            searchBar.resignFirstResponder()
            dismiss(animated: true, completion: nil)
            
            //Create the search request
        if let city: String = searchBar.text?.trimmingCharacters(in: .whitespaces) {
        print("\(city)")
            let realm = try! Realm()
            let newCity: City = City(value: ["city": city, "title": searchBar.text?.trimmingCharacters(in: .whitespaces)])
            try! realm.write {
                realm.add(newCity, update: .all)
            }
            loadCities()
            tableView.reloadData()
        }
        print("City count: \(cities.count)")
        
    }
    
    //Realm Functions
    func loadCities() {
        let realm = try! Realm()
        let results = realm.objects(City.self)
        cities.removeAll()
        for result in results {
            cities.append(result)
        }
    }
    
    //Weather JSON functions
    func getWeather() {
        let defaults = UserDefaults()
        let recoveredJsonData = defaults.object(forKey: "data")
        if recoveredJsonData != nil {
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
                
                } else {
                    tableView.tableFooterView = UIView(frame: CGRect.zero)
                    let backgroundImage = UIImage(named: "daytime")
                    let imageView = UIImageView(image: backgroundImage)
                    imageView.contentMode = .scaleAspectFill
                    self.tableView.backgroundView = imageView
                }
                //continue...
            } else {
                DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "No Weather Data Found", message: "Our weather service is currently experiencing issues. Please check back later. Thanks!", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
            }
        } else {
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "No Weather Data Found", message: "Our weather service is currently experiencing issues. Please check back later. Thanks!", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
}
