/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import MapKit
import UIKit
import Parse
import CoreLocation
import AddressBookUI

class ViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate, SettingsTableViewControllerDelegate {
    
    func didClose(controller: SettingsTableViewController) {
        self.dismiss(animated: true, completion: nil)
        print("\("Will is awesome")")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "openSettings" {
            let navigationController: UINavigationController = segue.destination as! UINavigationController
            let settingsTVController: SettingsTableViewController = navigationController.viewControllers[0] as! SettingsTableViewController
            settingsTVController.delegate = self
        }
    }
    
    var locationHasBeenFound = false
    var buttonIsSelected = false
    let locationManager = CLLocationManager()

    @IBOutlet weak var whiteBackgroundWeatherView: UIView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var topBackgroundView: UIView!
    @IBOutlet weak var setCurrentLocationView: UIButton!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var sevenDayDateLabel: UILabel!
    @IBOutlet weak var sevenDayWeatherImageView: UIImageView!
    @IBOutlet weak var sevenDayHighLowTempLabel: UILabel!
    
    @IBOutlet weak var sevenDayTwoDateLabel: UILabel!
    @IBOutlet weak var sevenDayTwoWeatherImageView: UIImageView!
    @IBOutlet weak var sevenDayTwoHighLowTempLabel: UILabel!
    
    @IBOutlet weak var sevenDayThreeDateLabel: UILabel!
    @IBOutlet weak var sevenDayThreeWeatherImageView: UIImageView!
    @IBOutlet weak var sevenDayThreeHighLowTempLabel: UILabel!
    
    @IBOutlet weak var sevenDayFourDateLabel: UILabel!
    @IBOutlet weak var sevenDayFourWeatherImageView: UIImageView!
    @IBOutlet weak var sevenDayFourHighLowTempLabel: UILabel!
   
    @IBOutlet weak var sevenDayFiveDateLabel: UILabel!
    @IBOutlet weak var sevenDayFiveWeatherImageView: UIImageView!
    @IBOutlet weak var sevenDayFiveHighLowTempLabel: UILabel!
    
    @IBOutlet weak var sevenDaySixDateLabel: UILabel!
    @IBOutlet weak var sevenDaySixWeatherImageView: UIImageView!
    @IBOutlet weak var sevenDaySixHighLowTempLabel: UILabel!
    
    @IBOutlet weak var sevenDaySevenDateLabel: UILabel!
    @IBOutlet weak var sevenDaySevenWeatherImageView: UIImageView!
    @IBOutlet weak var sevenDaySevenHighLowTempLabel: UILabel!
    
    @IBOutlet weak var walkMeLabel: UILabel!
    @IBAction func dropWisdomButton(_ sender: UIButton) {
//        buttonIsSelected = !buttonIsSelected
        self.updateDropWisdomButton()
    }
    @IBAction func setCurrentLocation(_ sender: UIButton) {
        self.getTemperature()
    }
    
    @IBOutlet weak var searchButtonView: UIButton!
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
            searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Spinner Activity indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Create the search request
        let address = searchBar.text
        self.forwardGeocoding(address: "\(address!)")
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        whiteBackgroundWeatherView.isHidden = true

        self.showSpinnerOverlay()
        
        self.walkMeLabel.alpha = 0
        
        self.walkMeLabel.layer.masksToBounds = true
        self.walkMeLabel.layer.cornerRadius = 10
        
        //Location updated when app is being used
        self.topBackgroundView.layer.cornerRadius = 5
        self.topBackgroundView.layer.borderColor = UIColor.white.cgColor
        self.topBackgroundView.layer.borderWidth = 1
        
        self.setCurrentLocationView.layer.cornerRadius = 5
        
        self.searchButtonView.layer.cornerRadius = 5
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func showSpinnerOverlay() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locationHasBeenFound == false {
            self.showSpinnerOverlay()
            self.whiteBackgroundWeatherView.isHidden = false
            self.getTemperature()
            locationHasBeenFound = true
        }
        }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled", message: "In order to get your local weather we need your location", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func updateWalkMeLabel() {
        let colorLabel = [UIColor.blue, UIColor.red, UIColor.purple, UIColor.black, UIColor(red: 1, green: 0.4314, blue: 0, alpha: 1.0), UIColor(red: 1, green: 0, blue: 0.898, alpha: 1.0), UIColor(red: 0, green: 0.5804, blue: 0.8078, alpha: 1.0)]
        let randomColor = colorLabel[Int(arc4random_uniform(UInt32(colorLabel.count)))]
        self.walkMeLabel.textColor! = randomColor
        
        let textLabel = ["Food makes me soooo happy.",
                         "Can we go outside?! Let's go play!",
                         "Yes! I will go fetch that ball!",
                         "How about a treat for a good dog?",
                         "I love my human!",
                         "Belly rubs are the best!",
                         "Peanut butter is one of my favorite treats.",
                         "I'm parched. Ice cubes and water please!",
                         "Am I a good dog?",
                         "Will sit for table scraps.",
                         "Sleep. Eat. Play. Repeat!",
                         "Love meeting new friends at the park!",
                         "Can I bring my new stick home?",
                         "Can I go chase the squirrels outside?"]
        let randomText = textLabel[Int(arc4random_uniform(UInt32(textLabel.count)))]
        self.walkMeLabel.text! = randomText
    }
    
    func updateDropWisdomButton () {
        self.updateWalkMeLabel()
        UIView.animate(withDuration: 3, delay: 0, options: [.curveEaseOut], animations: {
            self.walkMeLabel.alpha = 1 },
            completion: {
                finished in
                if finished {
                    //Once the label is completely invisible, set the text and fade it back in
                    
                    // Fade in
                    UIView.animate(withDuration: 4, delay: 0, options: [.curveEaseOut], animations: {
                        self.walkMeLabel.alpha = 0.0 },
                                   completion: nil) }
                })
    }
    
    
//        self.updateWalkMeLabel ()
//        //needs to click to start animation because it needs to unhide it... why?
//        if buttonIsSelected {
//            UIView.animate(withDuration: 4, delay: 0, options: [.curveEaseOut],
//                    animations: {
//                        self.walkMeLabel.center.y -= self.view.bounds.midY
//                        self.view.layoutIfNeeded()
//            }, completion:
//                { finished in
//                    if finished {
//                    self.walkMeLabel.isHidden = true
//                    self.walkMeLabel.layer.removeAllAnimations()
//                    self.walkMeLabel.frame.origin.y = 600.0
//                    self.walkMeLabel.frame.origin.x = 80.0
//                    }
//            })
//        }
//        else {
//            walkMeLabel.isHidden = true
//        }
//    }
    
    func getWeatherIcon (theImageView: UIImageView, theCondition: String) {
        
        //partly cloud icon
        if theCondition.range(of: "Mostly Cloudy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "clouds") }
        else if theCondition.range(of: "Mostly Cloudy with Haze") != nil {
            theImageView.image! = #imageLiteral(resourceName: "clouds") }
        else if theCondition.range(of: "Mostly Cloudy and Breezy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "clouds") }
        else if theCondition.range(of: "Partly Cloudy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "clouds") }
        else if theCondition.range(of: "Partly Cloudy with Haze") != nil {
            theImageView.image! = #imageLiteral(resourceName: "clouds") }
        else if theCondition.range(of: "Partly Cloudy and Breezy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "clouds") }
        else if theCondition.range(of: "NA") != nil {
            theImageView.image! = #imageLiteral(resourceName: "nil") }
        else if theCondition.range(of: "") != nil {
            theImageView.image! = #imageLiteral(resourceName: "nil") }
        else if theCondition.range(of: "Claire") != nil {
            theImageView.image! = #imageLiteral(resourceName: "sunny") }

        //clear day icon
        else if theCondition.range(of: "Fair") != nil {
            theImageView.image! = #imageLiteral(resourceName: "sunny") }
        else if theCondition.range(of: "Clear") != nil {
            theImageView.image! = #imageLiteral(resourceName: "sunny") }
        else if theCondition.range(of: "Fair with Haze") != nil {
            theImageView.image! = #imageLiteral(resourceName: "sunny") }
        else if theCondition.range(of: "Clear with Haze") != nil {
            theImageView.image! = #imageLiteral(resourceName: "sunny") }
        else if theCondition.range(of: "Fair and Breezy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "sunny")  }
        else if theCondition.range(of: "Clear and Breezy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "sunny")  }
        else if theCondition.range(of: "A Few Clouds") != nil {
            theImageView.image! = #imageLiteral(resourceName: "sunny")  }
        else if theCondition.range(of: "A Few Clouds with Haze") != nil {
            theImageView.image! = #imageLiteral(resourceName: "sunny")  }
        else if theCondition.range(of: "A Few Clouds and Breezy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "sunny")  }
        
        //cloudy icon
        else if theCondition.range(of: "Overcast") != nil {
            theImageView.image! = #imageLiteral(resourceName: "cloudy") }
        else if theCondition.range(of: "Overcast with Haze") != nil {
            theImageView.image! = #imageLiteral(resourceName: "cloudy") }
        else if theCondition.range(of: "Overcast and Breezy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "cloudy") }
        
        
        //fog icon
        else if theCondition.range(of: "Fog") != nil {
            theImageView.image! = #imageLiteral(resourceName: "cloudy") }
        else if theCondition.range(of: "Smoke") != nil {
            theImageView.image! = #imageLiteral(resourceName: "cloudy") }
        else if theCondition.range(of: "Haze") != nil {
            theImageView.image! = #imageLiteral(resourceName: "cloudy") }
        
        //hail icon
        else if theCondition.range(of: "Ice") != nil {
            theImageView.image! = #imageLiteral(resourceName: "hail") }
        else if theCondition.range(of: "Pellets") != nil {
            theImageView.image! = #imageLiteral(resourceName: "hail") }
        else if theCondition.range(of: "Hail") != nil {
            theImageView.image! = #imageLiteral(resourceName: "hail") }
        
        //raining icon
        else if theCondition.range(of: "Rain") != nil {
            theImageView.image! = #imageLiteral(resourceName: "raining1") }
        else if theCondition.range(of: "Drizzle") != nil {
            theImageView.image! = #imageLiteral(resourceName: "raining1") }
        else if theCondition.range(of: "Showers") != nil {
            theImageView.image! = #imageLiteral(resourceName: "raining1") }
        
        //sleet icon
        else if theCondition.range(of: "Freezing") != nil {
            theImageView.image! = #imageLiteral(resourceName: "sleet") }
        
        //snowing icon
        else if theCondition.range(of: "Snow") != nil {
            theImageView.image! = #imageLiteral(resourceName: "hail") }
        
        //thunderstorm icon
        else if theCondition.range(of: "Thunderstorm") != nil {
            theImageView.image! = #imageLiteral(resourceName: "thunderstorm1") }
        
        //Windy icon
        else if theCondition.range(of: "Windy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "windy") }
    }
    
    func getImage(temperature: String, condition: String) {
        
        //random images for 6 buckets - Snow, Cold, Rain, Nice, Cloudy and Lightning
        let pandaSnowWeatherImages = [#imageLiteral(resourceName: "IMG_8382")]
        let randomSnow = pandaSnowWeatherImages[Int(arc4random_uniform(UInt32(pandaSnowWeatherImages.count)))]
        let pandaColdWeatherImages = [#imageLiteral(resourceName: "faceCute"), #imageLiteral(resourceName: "onTheCouch"), #imageLiteral(resourceName: "peakingOut"), #imageLiteral(resourceName: "cold"), #imageLiteral(resourceName: "sleep"), #imageLiteral(resourceName: "ballInMouth"), #imageLiteral(resourceName: "inTheHall"), #imageLiteral(resourceName: "onTheBed"), #imageLiteral(resourceName: "pandaart"), #imageLiteral(resourceName: "sohappy"), #imageLiteral(resourceName: "sleepingagain"), #imageLiteral(resourceName: "toyscarpet"), #imageLiteral(resourceName: "sleepy"),#imageLiteral(resourceName: "pandapumpkin"),  #imageLiteral(resourceName: "pandapumpkin2")]
        let randomCold = pandaColdWeatherImages[Int(arc4random_uniform(UInt32(pandaColdWeatherImages.count)))]
        let pandaRainWeatherImages = [#imageLiteral(resourceName: "image2"), #imageLiteral(resourceName: "IMG_1680"), #imageLiteral(resourceName: "IMG_3485"), #imageLiteral(resourceName: "rain"), #imageLiteral(resourceName: "ballInMouth"), #imageLiteral(resourceName: "onTheBed"), #imageLiteral(resourceName: "pumpkin"),#imageLiteral(resourceName: "toyscarpet"), #imageLiteral(resourceName: "sohappy"), #imageLiteral(resourceName: "sleepingagain"),#imageLiteral(resourceName: "duskRain"),#imageLiteral(resourceName: "rainDog"),#imageLiteral(resourceName: "bluepanda")]
        let randomRain = pandaRainWeatherImages[Int(arc4random_uniform(UInt32(pandaRainWeatherImages.count)))]
        let pandaNiceWeatherImages = [#imageLiteral(resourceName: "duskOutside"), #imageLiteral(resourceName: "happyOnBench"), #imageLiteral(resourceName: "image6"), #imageLiteral(resourceName: "stick"), #imageLiteral(resourceName: "onTheMountain"), #imageLiteral(resourceName: "onTheMountain2"),#imageLiteral(resourceName: "balconyimage"),#imageLiteral(resourceName: "heatherfarm"), #imageLiteral(resourceName: "byTheTre"), #imageLiteral(resourceName: "civicPark"), #imageLiteral(resourceName: "niceDay"), #imageLiteral(resourceName: "sunnyDay"), #imageLiteral(resourceName: "inSFNice"), #imageLiteral(resourceName: "ontherocks"), #imageLiteral(resourceName: "onTheWaterwithLuvi"), #imageLiteral(resourceName: "pandapumpkin"),#imageLiteral(resourceName: "baseballpanda")]
        let randomNice = pandaNiceWeatherImages[Int(arc4random_uniform(UInt32(pandaNiceWeatherImages.count)))]
        let pandaCloudyWeatherImages = [#imageLiteral(resourceName: "image3"), #imageLiteral(resourceName: "IMG_1974"), #imageLiteral(resourceName: "IMG_3548"), #imageLiteral(resourceName: "onRedChair"), #imageLiteral(resourceName: "onTheTile"), #imageLiteral(resourceName: "treatrawhide"), #imageLiteral(resourceName: "ballInMouth"), #imageLiteral(resourceName: "inTheHall"), #imageLiteral(resourceName: "pumpkin"),#imageLiteral(resourceName: "toyscarpet"),#imageLiteral(resourceName: "sohappy"),#imageLiteral(resourceName: "legscrossed"), #imageLiteral(resourceName: "sleepy"), #imageLiteral(resourceName: "duskRain"), #imageLiteral(resourceName: "parkGreen"), #imageLiteral(resourceName: "pandapumpkin2"), #imageLiteral(resourceName: "slycloudy"),#imageLiteral(resourceName: "flowerpanda")]
        let randomCloudy = pandaCloudyWeatherImages[Int(arc4random_uniform(UInt32(pandaCloudyWeatherImages.count)))]
        let pandaLightningWeatherImages = [#imageLiteral(resourceName: "atTheDoor"), #imageLiteral(resourceName: "scared"), #imageLiteral(resourceName: "IMG_2068"), #imageLiteral(resourceName: "IMG_2798"), #imageLiteral(resourceName: "IMG_7199"), #imageLiteral(resourceName: "underDrawer"), #imageLiteral(resourceName: "soSmall"), #imageLiteral(resourceName: "pandaart"),#imageLiteral(resourceName: "sleepingagain")]
        let randomLightning = pandaLightningWeatherImages[Int(arc4random_uniform(UInt32(pandaLightningWeatherImages.count)))]
        
        let theValue = Double(temperature)
//        let theStringValue = String(temperature)
        let theCondition = condition
        
        print("theValue: " + "\(theValue)")
        print("condition: " + "\(theCondition)")
        
        // Temperature is nil
        if theValue == nil {
            self.dogImageView.image! = randomCold }
        
        //<32 degreesF
        else if theValue! < 32 && theCondition.range(of:"Clouds") != nil {
            self.dogImageView.image! = randomCold }
        else if theValue! < 32 && theCondition.range(of:"Cloudy") != nil {
            self.dogImageView.image! = randomCold }
        else if theValue! < 32 && theCondition.range(of:"Fair") != nil {
            self.dogImageView.image! = randomCold }
        else if theValue! < 32 && theCondition.range(of:"Clear") != nil {
            self.dogImageView.image! = randomCold }
        else if theValue! < 32 && theCondition.range(of:"Overcast") != nil {
            self.dogImageView.image! = randomCloudy }
        else if theValue! < 32 && theCondition.range(of:"Fog") != nil {
            self.dogImageView.image! = randomCloudy }
        else if theValue! < 32 && theCondition.range(of:"Rain") != nil {
            self.dogImageView.image! = randomSnow }
        else if theValue! < 32 && theCondition.range(of:"storm") != nil {
            self.dogImageView.image! = randomSnow }
        else if theValue! < 32 && theCondition.range(of:"hurricane") != nil {
            self.dogImageView.image! = randomSnow }
        else if theValue! < 32 && theCondition.range(of:"Snow") != nil {
            self.dogImageView.image! = randomSnow }
        else if theValue! < 32 && theCondition.range(of: "NA") != nil {
            self.dogImageView.image! = randomSnow }
        else if theValue! < 32 && theCondition.range(of: "") != nil {
            self.dogImageView.image! = randomSnow }
            
        // 32 && < 50
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Clouds") != nil {
            self.dogImageView.image! = randomCold }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Cloudy") != nil {
            self.dogImageView.image! = randomCold }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Fair") != nil {
            self.dogImageView.image! = randomCold }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Clear") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Overcast") != nil {
            self.dogImageView.image! = randomCloudy }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Fog") != nil {
            self.dogImageView.image! = randomCloudy }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Rain") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"storm") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"hurricane") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"showers") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Thunderstorm") != nil {
            self.dogImageView.image! = randomLightning }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"NA") != nil {
            self.dogImageView.image! = randomCold }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"") != nil {
            self.dogImageView.image! = randomCold }
        
        // 50 && < 70
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Clouds") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Cloudy") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Fair") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Clear") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Overcast") != nil {
            self.dogImageView.image! = randomCloudy }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Fog") != nil {
            self.dogImageView.image! = randomCloudy }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Rain") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"storm") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"hurricane") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"showers") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Thunderstorm") != nil {
            self.dogImageView.image! = randomLightning }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"NA") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"") != nil {
            self.dogImageView.image! = randomNice }

            
        // 70 && < 80
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Clouds") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Cloudy") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Fair") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Clear") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Overcast") != nil {
            self.dogImageView.image! = randomCloudy }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Fog") != nil {
            self.dogImageView.image! = randomCloudy }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Rain") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"storm") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"hurricane") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"showers") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Thunderstorm") != nil {
            self.dogImageView.image! = randomLightning }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"NA") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"") != nil {
            self.dogImageView.image! = randomNice }
            
        // 80 && < 90
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Clouds") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Cloudy") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Fair") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Clear") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Overcast") != nil {
            self.dogImageView.image! = randomCloudy }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Fog") != nil {
            self.dogImageView.image! = randomCloudy }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Rain") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"storm") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"hurricane") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"showers") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Thunderstorm") != nil {
            self.dogImageView.image! = randomLightning }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"NA") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"") != nil {
            self.dogImageView.image! = randomNice }
            
            
        // > 90
        else if theValue! >= 90 && theCondition.range(of:"Clouds") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 90 && theCondition.range(of:"Cloudy") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 90 && theCondition.range(of:"Fair") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 90 && theCondition.range(of:"Clear") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 90 && theCondition.range(of:"Overcast") != nil {
            self.dogImageView.image! = randomCloudy }
        else if theValue! >= 90 && theCondition.range(of:"Fog") != nil {
            self.dogImageView.image! = randomCloudy }
        else if theValue! >= 90 && theCondition.range(of:"Rain") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 90 && theCondition.range(of:"storm") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 90 && theCondition.range(of:"hurricane") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 90 && theCondition.range(of:"showers") != nil {
            self.dogImageView.image! = randomRain }
        else if theValue! >= 90 && theCondition.range(of:"Thunderstorm") != nil {
            self.dogImageView.image! = randomLightning }
        else if theValue! >= 90 && theCondition.range(of:"NA") != nil {
            self.dogImageView.image! = randomNice }
        else if theValue! >= 90 && theCondition.range(of:"") != nil {
            self.dogImageView.image! = randomNice }
        
        else {
            self.dogImageView.image! = randomNice
        }
        }
    
    /*let freezingTemp: CountableClosedRange = -100...30
     let coldTemp: CountableClosedRange = 30...50
     let coolTemp: CountableClosedRange = 50...70
     let warmTemp: CountableClosedRange = 70...80
     let hotTemp: CountableClosedRange = 80...90
     let superHotTemp: CountableClosedRange = 90...150
     *///if inputString is within freezingTemp
    
    func getTemperature() {
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
                
                let city = json["productionCenter"] as! String
                cityLabel.text! = city
                print("city: \(city)")
            
                let forecast = json["data"] as! [String:Any]?
                let weatherDescription: NSArray = forecast!["text"] as! NSArray
                print("\(weatherDescription[0])")
                weatherLabel.text! = weatherDescription[0] as! String
            
                self.getImage(temperature: temp, condition: condition)
                self.getWeatherIcon(theImageView: self.weatherImageView, theCondition: condition)
                
                //7-day forecast, day 1 Date, Weather Icon, and High/Low Temp
                let sevenDayDate = json["time"] as! [String:Any]?
                let sevenDayDateDescription: NSArray = sevenDayDate!["startPeriodName"] as! NSArray
                print("\(sevenDayDateDescription[1])")
                print("\(sevenDayDateDescription[12])")
                
                let dateCount = sevenDayDateDescription.count
                print("dateCount: " + "\(dateCount)")
                
                // get the first three characters of the Date
                let DayOne = String((sevenDayDateDescription[2] as! String).characters.prefix(3))
                print("\(DayOne)")
                let DayTwo = String((sevenDayDateDescription[4] as! String).characters.prefix(3))
                let DayThree = String((sevenDayDateDescription[6] as! String).characters.prefix(3))
                let DayFour = String((sevenDayDateDescription[8] as! String).characters.prefix(3))
                let DayFive = String((sevenDayDateDescription[10] as! String).characters.prefix(3))
                print("\(DayFive)")
                let DaySix = String((sevenDayDateDescription[12] as! String).characters.prefix(3))
                print("\(DaySix)")
                print("\(dateCount)")
                
                if dateCount > 13 {
                    let DaySeven = String((sevenDayDateDescription[13] as! String).characters.prefix(3))
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
                
                //Setting the temperature for input string in func getWeatherIcon and getImage
                let sevenDayOneWeekTempZero: String = sevenDayTempDescription[0] as! String
                let sevenDayTwoWeekTempOne: String = sevenDayTempDescription[1] as! String
                let sevenDayThreeWeekTempTwo: String = sevenDayTempDescription[2] as! String
                let sevenDayFourWeekTempThree: String = sevenDayTempDescription[3] as! String
                let sevenDayFiveWeekTempFour: String = sevenDayTempDescription[4] as! String
                let sevenDaySixWeekTempFive: String = sevenDayTempDescription[5] as! String
                let sevenDaySevenWeekTempSix: String = sevenDayTempDescription[6] as! String
                
                //Setting the condition for input string in func getWeatherIcon and getImage
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
                
                self.getImage(temperature: sevenDayOneWeekTempZero, condition: sevenDayOneConditionDescriptionZero)
                self.getWeatherIcon(theImageView: sevenDayWeatherImageView, theCondition: sevenDayOneConditionDescriptionZero)
                
                self.getImage(temperature: sevenDayTwoWeekTempOne, condition: sevenDayTwoConditionDescriptionOne)
                self.getWeatherIcon(theImageView: sevenDayTwoWeatherImageView, theCondition: sevenDayTwoConditionDescriptionOne)
                
                self.getImage(temperature: sevenDayThreeWeekTempTwo, condition: sevenDayThreeConditionDescriptionTwo)
                self.getWeatherIcon(theImageView: sevenDayThreeWeatherImageView, theCondition: sevenDayThreeConditionDescriptionTwo)
                
                self.getImage(temperature: sevenDayFourWeekTempThree, condition: sevenDayFourConditionDescriptionThree)
                self.getWeatherIcon(theImageView: sevenDayFourWeatherImageView, theCondition: sevenDayFourConditionDescriptionThree)
                
                self.getImage(temperature: sevenDayFiveWeekTempFour, condition: sevenDayFiveConditionDescriptionFour)
                self.getWeatherIcon(theImageView: sevenDayFiveWeatherImageView, theCondition: sevenDayFiveConditionDescriptionFour)
                
                self.getImage(temperature: sevenDaySixWeekTempFive, condition: sevenDaySixConditionDescriptionFive)
                self.getWeatherIcon(theImageView: sevenDaySixWeatherImageView, theCondition: sevenDaySixConditionDescriptionFive)
                
                self.getImage(temperature: sevenDaySevenWeekTempSix, condition: sevenDaySevenConditionDescriptionSix)
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
}
    
    //forward geocoding function
    func forwardGeocoding(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                //need to add an error message
                print(error)
                return
            }
            if placemarks!.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                let lat = coordinate!.latitude
                let long = coordinate!.longitude
                print("\nlat: \(lat), long: \(long)")
                
                //                if placemark!.areasOfInterest!.count > 0 {
                //                    let areaOfInterest = placemark!.areasOfInterest![0]
                //                    print(areaOfInterest)
                //                } else {
                //                    print("No area of interest found.")
                //                }
                
                let weatherURL = NSURL(string: "http://forecast.weather.gov/MapClick.php?lat=\(lat)&lon=\(long)&unit=0&lg=english&FcstType=json&TextType=1")
                let weatherData = try? Data(contentsOf: weatherURL! as URL)
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: weatherData!, options:.allowFragments) as? [String:Any] {
                        print(json as Any)
                        
                        if json["currentobservation"] != nil {
                        
//                        let currentObservation = json["currentobservation"] as! [String:Any]?
//                        let state: String = currentObservation?["state"] as! String
//
//                        if state != nil {
                        
                        let currentObservation = json["currentobservation"] as! [String:Any]?
                        let temp: String = currentObservation?["Temp"] as! String
                        let tempDegreesF = temp + "℉"
                        self.temperatureLabel.text! = tempDegreesF
                        print("tempDegreesF: \(tempDegreesF)")
                        
                        let weatherCondition = json["currentobservation"] as! [String:Any]?
                        let condition: String = weatherCondition?["Weather"] as! String
                        self.conditionLabel.text! = condition
                        print("condition: \(condition)")
                            
                        let city = json["productionCenter"] as! String
                        self.cityLabel.text! = city
                        print("city: \(city)")
                        
                        let forecast = json["data"] as! [String:Any]?
                        let weatherDescription: NSArray = forecast!["text"] as! NSArray
                        print("\(weatherDescription[0])")
                        self.weatherLabel.text! = weatherDescription[0] as! String
                        
                        self.getImage(temperature: temp, condition: condition)
                        self.getWeatherIcon(theImageView: self.weatherImageView, theCondition: condition)
                        
                        //7-day forecast, day 1 Date, Weather Icon, and High/Low Temp
                        let sevenDayDate = json["time"] as! [String:Any]?
                        let sevenDayDateDescription: NSArray = sevenDayDate!["startPeriodName"] as! NSArray
                        print("\(sevenDayDateDescription[1])")
                        print("\(sevenDayDateDescription[12])")
                        
                        let dateCount = sevenDayDateDescription.count
                        print("dateCount: " + "\(dateCount)")
                        
                        // get the first three characters of the Date
                        let DayOne = String((sevenDayDateDescription[2] as! String).characters.prefix(3))
                        print("\(DayOne)")
                        let DayTwo = String((sevenDayDateDescription[4] as! String).characters.prefix(3))
                        let DayThree = String((sevenDayDateDescription[6] as! String).characters.prefix(3))
                        let DayFour = String((sevenDayDateDescription[8] as! String).characters.prefix(3))
                        let DayFive = String((sevenDayDateDescription[10] as! String).characters.prefix(3))
                        print("\(DayFive)")
                        let DaySix = String((sevenDayDateDescription[12] as! String).characters.prefix(3))
                        print("\(DaySix)")
                        print("\(dateCount)")
                        
                        if dateCount > 13 {
                            let DaySeven = String((sevenDayDateDescription[13] as! String).characters.prefix(3))
                            print("Day Seven: " + "\(DaySeven)")
                            self.sevenDayDateLabel.text! = DayOne
                            self.sevenDayTwoDateLabel.text! = DayTwo
                            self.sevenDayThreeDateLabel.text! = DayThree
                            self.sevenDayFourDateLabel.text! = DayFour
                            self.sevenDayFiveDateLabel.text! = DayFive
                            self.sevenDaySixDateLabel.text! = DaySix
                            self.sevenDaySevenDateLabel.text! = DaySeven }
                            
                        else {
                            
                            if dateCount <= 13 {
                                self.sevenDayDateLabel.text! = DayOne
                                self.sevenDayTwoDateLabel.text! = DayTwo
                                self.sevenDayThreeDateLabel.text! = DayThree
                                self.sevenDayFourDateLabel.text! = DayFour
                                self.sevenDayFiveDateLabel.text! = DayFive
                                self.sevenDaySixDateLabel.text! = DaySix
                                self.sevenDaySevenDateLabel.text! = "NA" }
                        }
                        
                        let sevenDayTemp = json["data"] as! [String:Any]?
                        let sevenDayTempDescription: NSArray = sevenDayTemp!["temperature"] as! NSArray
                        print("\(sevenDayTempDescription[0], sevenDayTempDescription[1])")
                        
                        let tempCount = sevenDayTempDescription.count
                        print("tempCount: " + "\(tempCount)")
                        if tempCount > 13 {
                            self.sevenDayHighLowTempLabel.text! = "\(sevenDayTempDescription[1])" + " | " + "\(sevenDayTempDescription[2])"
                            self.sevenDayTwoHighLowTempLabel.text! = "\(sevenDayTempDescription[3])" + " | " + "\(sevenDayTempDescription[4])"
                            self.sevenDayThreeHighLowTempLabel.text! = "\(sevenDayTempDescription[5])" + " | " + "\(sevenDayTempDescription[6])"
                            self.sevenDayFourHighLowTempLabel.text! = "\(sevenDayTempDescription[7])" + " | " + "\(sevenDayTempDescription[8])"
                            self.sevenDayFiveHighLowTempLabel.text! = "\(sevenDayTempDescription[9])" + " | " + "\(sevenDayTempDescription[10])"
                            self.sevenDaySixHighLowTempLabel.text! = "\(sevenDayTempDescription[11])" + " | " + "\(sevenDayTempDescription[12])"
                            self.sevenDaySevenHighLowTempLabel.text! = "\(sevenDayTempDescription[12])" + " | " + "\(sevenDayTempDescription[13])"
                        }
                        
                        if tempCount <= 13 {
                            self.sevenDayHighLowTempLabel.text! = "\(sevenDayTempDescription[1])" + " | " + "\(sevenDayTempDescription[2])"
                            self.sevenDayTwoHighLowTempLabel.text! = "\(sevenDayTempDescription[3])" + " | " + "\(sevenDayTempDescription[4])"
                            self.sevenDayThreeHighLowTempLabel.text! = "\(sevenDayTempDescription[5])" + " | " + "\(sevenDayTempDescription[6])"
                            self.sevenDayFourHighLowTempLabel.text! = "\(sevenDayTempDescription[7])" + " | " + "\(sevenDayTempDescription[8])"
                            self.sevenDayFiveHighLowTempLabel.text! = "\(sevenDayTempDescription[9])" + " | " + "\(sevenDayTempDescription[10])"
                            self.sevenDaySixHighLowTempLabel.text! = "\(sevenDayTempDescription[11])" + " | " + "\(sevenDayTempDescription[12])"
                            self.sevenDaySevenHighLowTempLabel.text! = "\(sevenDayTempDescription[12])" + " | " + "NA"
                            
                        }
                        
                        //Setting the temperature for input string in func getWeatherIcon and getImage
                        let sevenDayOneWeekTempZero: String = sevenDayTempDescription[0] as! String
                        let sevenDayTwoWeekTempOne: String = sevenDayTempDescription[1] as! String
                        let sevenDayThreeWeekTempTwo: String = sevenDayTempDescription[2] as! String
                        let sevenDayFourWeekTempThree: String = sevenDayTempDescription[3] as! String
                        let sevenDayFiveWeekTempFour: String = sevenDayTempDescription[4] as! String
                        let sevenDaySixWeekTempFive: String = sevenDayTempDescription[5] as! String
                        let sevenDaySevenWeekTempSix: String = sevenDayTempDescription[6] as! String
                        
                        //Setting the condition for input string in func getWeatherIcon and getImage
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
                        
                        self.getImage(temperature: sevenDayOneWeekTempZero, condition: sevenDayOneConditionDescriptionZero)
                        self.getWeatherIcon(theImageView: self.sevenDayWeatherImageView, theCondition: sevenDayOneConditionDescriptionZero)
                        
                        self.getImage(temperature: sevenDayTwoWeekTempOne, condition: sevenDayTwoConditionDescriptionOne)
                        self.getWeatherIcon(theImageView: self.sevenDayTwoWeatherImageView, theCondition: sevenDayTwoConditionDescriptionOne)
                        
                        self.getImage(temperature: sevenDayThreeWeekTempTwo, condition: sevenDayThreeConditionDescriptionTwo)
                        self.getWeatherIcon(theImageView: self.sevenDayThreeWeatherImageView, theCondition: sevenDayThreeConditionDescriptionTwo)
                        
                        self.getImage(temperature: sevenDayFourWeekTempThree, condition: sevenDayFourConditionDescriptionThree)
                        self.getWeatherIcon(theImageView: self.sevenDayFourWeatherImageView, theCondition: sevenDayFourConditionDescriptionThree)
                        
                        self.getImage(temperature: sevenDayFiveWeekTempFour, condition: sevenDayFiveConditionDescriptionFour)
                        self.getWeatherIcon(theImageView: self.sevenDayFiveWeatherImageView, theCondition: sevenDayFiveConditionDescriptionFour)
                        
                        self.getImage(temperature: sevenDaySixWeekTempFive, condition: sevenDaySixConditionDescriptionFive)
                        self.getWeatherIcon(theImageView: self.sevenDaySixWeatherImageView, theCondition: sevenDaySixConditionDescriptionFive)
                        
                        self.getImage(temperature: sevenDaySevenWeekTempSix, condition: sevenDaySevenConditionDescriptionSix)
                        self.getWeatherIcon(theImageView: self.sevenDaySevenWeatherImageView, theCondition: sevenDaySevenConditionDescriptionSix)
                        
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
                
            }
        })
    }
    
}
