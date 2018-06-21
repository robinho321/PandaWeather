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
import CoreLocation
import AddressBookUI
import CoreData
import Photos

class ViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate, SettingsTableViewControllerDelegate, WeatherTableViewControllerDelegate
/*, CustomizePhotosViewControllerDelegate*/ {
    
//    func close() {
//            self.dismiss(animated: true, completion: nil)
//            print("\("Will is awesome")")
//    }
    
    func didClose(controller: SettingsTableViewController) {
        self.dismiss(animated: true, completion: nil)
        print("\("Will is awesome")")
    }
    
    func didCloseAgain(controller: WeatherTableViewController) {
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
        
        if segue.identifier == "openWeatherTVC" {
            let navigationController: UINavigationController = segue.destination as! UINavigationController
            let weatherTVC: WeatherTableViewController = navigationController.viewControllers[0] as! WeatherTableViewController
            weatherTVC.delegate = self
            }
        
//        if segue.identifier == "openCustomizePhotos" {
//            segue.photoFolderTableViewController.someSegueCouldHappen = true
//        }
        
    }
    
    var disclaimerHasBeenDisplayed = false
    
    //Weather Folder Arrays
    var niceUserImage = [PHAsset]()
    var cloudyUserImage = [PHAsset]()
    var coldUserImage = [PHAsset]()
    var rainUserImage = [PHAsset]()
    var lightningUserImage = [PHAsset]()
    var snowUserImage = [PHAsset]()
    
    let albumName = "Panda - Nice Weather"
    let albumName2 = "Panda - Cloudy Weather"
    let albumName3 = "Panda - Cold Weather"
    let albumName4 = "Panda - Rain Weather"
    let albumName5 = "Panda - Lightning Weather"
    let albumName6 = "Panda - Snow Weather"
    
    var albumFound: Bool = false
    var assetCollection: PHAssetCollection = PHAssetCollection()
    var photoAssets = PHFetchResult<AnyObject>()
    
    var currentNo: UInt32 = 0
    
    var locationHasBeenFound = false
    var buttonIsSelected = false
    let locationManager = CLLocationManager()
    
    @IBAction func customizePhotosSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "switchIsOn")
        
        if switchLabel.isOn {
            let AlertOnce = UserDefaults.standard
            if(!AlertOnce.bool(forKey: "oneTimeAlert")){
                
                let alert = UIAlertController(title: "Custom Photos", message: "\n Hello! You've just switched to custom photos! Here is how it works: \n \n ON position: loads only your custom photos. \n \n OFF position: loads only Panda images. \n \n Now press the search or the arrow to update your weather background!", preferredStyle: .alert)
                
                let DoNotShowAgainAction = UIAlertAction(title: "Do Not Show Again", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                    
                    AlertOnce.set(true , forKey: "oneTimeAlert")
                    AlertOnce.synchronize()
                    
                }
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    alert.removeFromParentViewController()
                }
                alert.addAction(cancelAction)
                alert.addAction(DoNotShowAgainAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        } else {
        }
    }
    
    @IBOutlet weak var getTemperatureActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var switchLabel: UISwitch!
    
    @IBOutlet weak var whiteStartUpView: UIView!
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
        if switchLabel.isOn {
            self.getUserTemperature()
        } else {
            self.getPandaTemperature()
        }
    }
    
    @IBOutlet weak var searchButtonView: UIButton!
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
            searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //ignoring user
//        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Spinner Activity indicator
//        let activityIndicator = UIActivityIndicatorView()
//        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
//        activityIndicator.center = self.view.center
//        activityIndicator.hidesWhenStopped = true
//
//        activityIndicator.startAnimating()
//
//        self.view.addSubview(activityIndicator)
        
        //Create the search request
        let address = searchBar.text
        if switchLabel.isOn {
            self.forwardGeocodingUser(address: "\(address!)")
        } else {
            self.forwardGeocodingPanda(address: "\(address!)")
        }

//        UIApplication.shared.endIgnoringInteractionEvents()
        
        //stop activity indicator -- spinner never shows up... fix later
//        activityIndicator.stopAnimating()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getTemperatureActivityIndicator.startAnimating()
        
        // Save Switch state in UserDefaults
        switchLabel.isOn = UserDefaults.standard.bool(forKey: "switchIsOn")
        
        whiteBackgroundWeatherView.isHidden = true

//        self.showSpinnerOverlay()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            }
    
    //The function to pull the data from the table.
    //Need to have it only fetch images that have "active" status!!
    func fetchCoreImage(_ active: String, _ type: String) ->[NSManagedObject]? {
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        //2
        let fetchRequest = NSFetchRequest<PandaImage>(entityName:"PandaImage")
        let resultPredicate1 = NSPredicate(format: "active = %@", "active")
        let resultPredicate2 = NSPredicate(format: "type = %@", type)
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates:[resultPredicate1, resultPredicate2])
        fetchRequest.predicate = compound
        let fetchedResult = try! managedContext.fetch(fetchRequest) as NSArray
        return fetchedResult as? [NSManagedObject]
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locationHasBeenFound == false {
            self.whiteBackgroundWeatherView.isHidden = false
            
            if switchLabel.isOn {
                self.getUserTemperature()
            } else {
                self.getPandaTemperature()
            }
            getTemperatureActivityIndicator.stopAnimating()
            whiteStartUpView.isHidden = true
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
    
    func getWeatherIcon (theImageView: UIImageView, theCondition: String) {
        
        //partly cloud icon
        if theCondition.range(of: "Mostly Cloudy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cloudy") }
        else if theCondition.range(of: "Mostly Cloudy with Haze") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cloudy") }
        else if theCondition.range(of: "Mostly Cloudy and Breezy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cloudy") }
        else if theCondition.range(of: "Partly Cloudy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cloudy") }
        else if theCondition.range(of: "Partly Cloudy with Haze") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cloudy") }
        else if theCondition.range(of: "Partly Cloudy and Breezy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cloudy") }
        else if theCondition.range(of: "Breezy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cloudy") }
        else if theCondition.range(of: "Frost") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cloudy") }
        else if theCondition.range(of: "Areas Frost then Sunny") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cloudy") }
        else if theCondition.range(of: "Frost then Mostly Sunny") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cloudy") }
        else if theCondition.range(of: "Partly Cloudy then Patchy Frost") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cloudy") }
        else if theCondition.range(of: "NA") != nil {
            theImageView.image! = #imageLiteral(resourceName: "nil") }
        else if theCondition.range(of: "") != nil {
            theImageView.image! = #imageLiteral(resourceName: "nil") }
        else if theCondition.range(of: "Clear") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Nice") }

        //clear day icon
        else if theCondition.range(of: "Fair") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Nice") }
        else if theCondition.range(of: "Clear") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Nice") }
        else if theCondition.range(of: "Sunny") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Nice") }
        else if theCondition.range(of: "Hot") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Nice") }
        else if theCondition.range(of: "Areas Frost then Sunny") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Nice") }
        else if theCondition.range(of: "Fair with Haze") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Nice") }
        else if theCondition.range(of: "Clear with Haze") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Nice") }
        else if theCondition.range(of: "Fair and Breezy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Nice") }
        else if theCondition.range(of: "Clear and Breezy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Nice") }
        else if theCondition.range(of: "A Few Clouds") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Nice") }
        else if theCondition.range(of: "A Few Clouds with Haze") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Nice") }
        else if theCondition.range(of: "A Few Clouds and Breezy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Nice") }
        
        //cloudy icon
        else if theCondition.range(of: "Clouds") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cold") }
        else if theCondition.range(of: "Overcast") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cold") }
        else if theCondition.range(of: "Patchy Frost") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cold") }
        else if theCondition.range(of: "Areas Frost") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cold") }
        else if theCondition.range(of: "Overcast with Haze") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cold") }
        else if theCondition.range(of: "Overcast and Breezy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cold") }
        
        
        //fog icon
        else if theCondition.range(of: "Fog") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cold") }
        else if theCondition.range(of: "Smoke") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cold") }
        else if theCondition.range(of: "Haze") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Cold") }
        
        //hail icon
        else if theCondition.range(of: "Ice") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Snow") }
        else if theCondition.range(of: "Pellets") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Snow") }
        else if theCondition.range(of: "Hail") != nil {
            theImageView.image! = #imageLiteral(resourceName: "Snow") }
        
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
            theImageView.image! = #imageLiteral(resourceName: "Snow") }
        
        //thunderstorm icon
        else if theCondition.range(of: "Thunderstorm") != nil {
            theImageView.image! = #imageLiteral(resourceName: "thunderstorm1") }
        else if theCondition.range(of: "T-storms") != nil {
            theImageView.image! = #imageLiteral(resourceName: "thunderstorm1") }
        
        //Windy icon
        else if theCondition.range(of: "Windy") != nil {
            theImageView.image! = #imageLiteral(resourceName: "windy") }
    }
    
    
    func FetchNiceWeatherCustomAlbumPhotos()
    {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status
            {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "title = %@", self.albumName)
                let collection: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                
                if let first_Obj:AnyObject = collection.firstObject{
                    print("first object of collection is: \(first_Obj)")
                    //found the album
                    self.albumFound = true
                    self.assetCollection = first_Obj as! PHAssetCollection

                    let allPhotos = PHAsset.fetchAssets(in: self.assetCollection, options: nil)
                    print(allPhotos.count)
                    allPhotos.enumerateObjects({ (object, count, stop) in
                        self.niceUserImage.append(object)
                        DispatchQueue.main.async(execute: {
                            let randomNice = Int(arc4random_uniform(UInt32(self.niceUserImage.count)))
                            self.dogImageView.image = self.convertImageFromAsset(asset: self.niceUserImage[randomNice])
                        })
                    })
                    print("Found \(allPhotos.count) images")
                    
                } else {
                    self.albumFound = false
                    let alert = UIAlertController(title: "No Nice Weather Images Found", message: "Please add an image to your Nice Weather folder, so the background can be populated with your image, instead of Panda's! Thanks :)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            }
        

        }
    }
    
    func FetchCloudyWeatherCustomAlbumPhotos()
    {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status
            {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "title = %@", self.albumName2)
                let collection: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                
                if let first_Obj:AnyObject = collection.firstObject{
                    print("first object of collection is: \(first_Obj)")
                    //found the album
                    self.albumFound = true
                    self.assetCollection = first_Obj as! PHAssetCollection
                    
                    let allPhotos = PHAsset.fetchAssets(in: self.assetCollection, options: nil)
                    print(allPhotos.count)
                    allPhotos.enumerateObjects({ (object, count, stop) in
                        self.cloudyUserImage.append(object)
                        DispatchQueue.main.async(execute: {
                            let randomCloudy = Int(arc4random_uniform(UInt32(self.cloudyUserImage.count)))
                            print("Random cloudy array number is \(randomCloudy)")
                            self.dogImageView.image = self.convertImageFromAsset(asset: self.cloudyUserImage[randomCloudy])
                        })
                    })
                    print("Found \(allPhotos.count) images")
                    
                } else {
                    self.albumFound = false
                    
                    let alert = UIAlertController(title: "No Cloudy Weather Images Found", message: "Please add an image to your Cloudy Weather folder, so the background can be populated with your image, instead of Panda's! Thanks :)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            }
        }
    }
    
    func FetchColdWeatherCustomAlbumPhotos()
    {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status
            {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "title = %@", self.albumName3)
                let collection: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                
                if let first_Obj:AnyObject = collection.firstObject{
                    print("first object of collection is: \(first_Obj)")
                    //found the album
                    self.albumFound = true
                    self.assetCollection = first_Obj as! PHAssetCollection
                    
                    let allPhotos = PHAsset.fetchAssets(in: self.assetCollection, options: nil)
                    print(allPhotos.count)
                    allPhotos.enumerateObjects({ (object, count, stop) in
                        self.coldUserImage.append(object)
                        DispatchQueue.main.async(execute: {
                            let randomCold = Int(arc4random_uniform(UInt32(self.coldUserImage.count)))
                            self.dogImageView.image = self.convertImageFromAsset(asset: self.coldUserImage[randomCold])
                        })
                    })
                    print("Found \(allPhotos.count) images")
                    
                } else {
                    self.albumFound = false
                    let alert = UIAlertController(title: "No Cold Weather Images Found", message: "Please add an image to your Cold Weather folder, so the background can be populated with your image, instead of Panda's! Thanks :)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
//                    self.dogImageView.image = #imageLiteral(resourceName: "smiling")
                }
                
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            }
        }
    }
    
    func FetchRainWeatherCustomAlbumPhotos()
    {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status
            {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "title = %@", self.albumName4)
                let collection: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                
                if let first_Obj:AnyObject = collection.firstObject{
                    print("first object of collection is: \(first_Obj)")
                    //found the album
                    self.albumFound = true
                    self.assetCollection = first_Obj as! PHAssetCollection
                    
                    let allPhotos = PHAsset.fetchAssets(in: self.assetCollection, options: nil)
                    print(allPhotos.count)
                    allPhotos.enumerateObjects({ (object, count, stop) in
                        self.rainUserImage.append(object)
                        DispatchQueue.main.async(execute: {
                            let randomRain = Int(arc4random_uniform(UInt32(self.rainUserImage.count)))
                            self.dogImageView.image = self.convertImageFromAsset(asset: self.rainUserImage[randomRain])
                        })
                    })
                    print("Found \(allPhotos.count) images")
                    
                } else {
                    self.albumFound = false
                    let alert = UIAlertController(title: "No Rain Weather Images Found", message: "Please add an image to your Rain Weather folder, so the background can be populated with your image, instead of Panda's! Thanks :)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }

            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            }
        }
    }
    
    func FetchLightningWeatherCustomAlbumPhotos()
    {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status
            {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "title = %@", self.albumName5)
                let collection: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                
                if let first_Obj:AnyObject = collection.firstObject{
                    print("first object of collection is: \(first_Obj)")
                    //found the album
                    self.albumFound = true
                    self.assetCollection = first_Obj as! PHAssetCollection
                    
                    let allPhotos = PHAsset.fetchAssets(in: self.assetCollection, options: nil)
                    print(allPhotos.count)
                    allPhotos.enumerateObjects({ (object, count, stop) in
                        self.lightningUserImage.append(object)
                        DispatchQueue.main.async(execute: {
                            let randomLightning = Int(arc4random_uniform(UInt32(self.lightningUserImage.count)))
                            self.dogImageView.image = self.convertImageFromAsset(asset: self.lightningUserImage[randomLightning])
                        })
                    })
                    print("Found \(allPhotos.count) images")
                    
                } else {
                    self.albumFound = false
                    let alert = UIAlertController(title: "No Lightning Weather Images Found", message: "Please add an image to your Lightning Weather folder, so the background can be populated with your image, instead of Panda's! Thanks :)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            }
            
            
        }
    }
    
    func FetchSnowWeatherCustomAlbumPhotos()
    {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status
            {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "title = %@", self.albumName6)
                let collection: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                
                if let first_Obj:AnyObject = collection.firstObject{
                    print("first object of collection is: \(first_Obj)")
                    //found the album
                    self.albumFound = true
                    self.assetCollection = first_Obj as! PHAssetCollection
                    
                    let allPhotos = PHAsset.fetchAssets(in: self.assetCollection, options: nil)
                    print(allPhotos.count)
                    allPhotos.enumerateObjects({ (object, count, stop) in
                        self.snowUserImage.append(object)
                        DispatchQueue.main.async(execute: {
                            let randomSnow = Int(arc4random_uniform(UInt32(self.snowUserImage.count)))
                            self.dogImageView.image = self.convertImageFromAsset(asset: self.snowUserImage[randomSnow])
                        })
                    })
                    print("Found \(allPhotos.count) images")
                    
                } else {
                    self.albumFound = false
                    let alert = UIAlertController(title: "No Snow Weather Images Found", message: "Please add an image to your Snow Weather folder, so the background can be populated with your image, instead of Panda's! Thanks :)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
                
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            }
        }
    }
    
//    func randomNumber(maximum: UInt32) -> Int {
//
//        var randomNumber: UInt32
//        repeat {
//            randomNumber = (arc4random_uniform(maximum))
//        }while currentNo == randomNumber
//        currentNo = randomNumber
//        return Int(randomNumber)
//    }
    
    func convertImageFromAsset(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            image = result!
        })
        return image
    }
    
    //USER IMAGE FETCH
    func getUserImage(temperature: String, condition: String) {

        //getUserImage func input Strings
        let theValue = Double(temperature)
        let theCondition = condition

        print("theValue: " + "\(String(describing: theValue))")
        print("condition: " + "\(theCondition)")

            //<32 degreesF
        if theValue! < 32 && theCondition.range(of:"Clouds") != nil {
            self.FetchColdWeatherCustomAlbumPhotos()
        }
        else if theValue! < 32 && theCondition.range(of:"Cloudy") != nil {
            self.FetchColdWeatherCustomAlbumPhotos()
        }
        else if theValue! < 32 && theCondition.range(of:"Snow") != nil {
            self.FetchSnowWeatherCustomAlbumPhotos()
        }
        else if theValue! < 32 && theCondition.range(of:"Fair") != nil {
            self.FetchColdWeatherCustomAlbumPhotos()
        }
        else if theValue! < 32 && theCondition.range(of:"Clear") != nil {
            self.FetchColdWeatherCustomAlbumPhotos()
        }
        else if theValue! < 32 && theCondition.range(of:"Overcast") != nil {
            self.FetchCloudyWeatherCustomAlbumPhotos()
        }
        else if theValue! < 32 && theCondition.range(of:"Fog") != nil {
            self.FetchCloudyWeatherCustomAlbumPhotos()
        }
        else if theValue! < 32 && theCondition.range(of:"Rain") != nil {
            self.FetchSnowWeatherCustomAlbumPhotos()
        }
        else if theValue! < 32 && theCondition.range(of:"storm") != nil {
            self.FetchSnowWeatherCustomAlbumPhotos()
        }
        else if theValue! < 32 && theCondition.range(of:"hurricane") != nil {
            self.FetchSnowWeatherCustomAlbumPhotos()
        }
        else if theValue! < 32 && theCondition.range(of: "NA") != nil {
            self.FetchSnowWeatherCustomAlbumPhotos()
        }
        else if theValue! < 32 && theCondition.range(of: "") != nil {
            self.FetchSnowWeatherCustomAlbumPhotos()
        }

            // 32 && < 50
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Clouds") != nil {
            self.FetchColdWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Cloudy") != nil {
            self.FetchColdWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Fair") != nil {
            self.FetchColdWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Clear") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Overcast") != nil {
            self.FetchCloudyWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Fog") != nil {
            self.FetchCloudyWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Rain") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"storm") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"hurricane") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"showers") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Thunderstorm") != nil {
            self.FetchLightningWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"NA") != nil {
            self.FetchColdWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"") != nil {
            self.FetchColdWeatherCustomAlbumPhotos()
        }

            // 50 && < 70
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Clouds") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Cloudy") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Fair") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Clear") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Overcast") != nil {
            self.FetchCloudyWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Fog") != nil {
            self.FetchCloudyWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Rain") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"storm") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"hurricane") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"showers") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Thunderstorm") != nil {
            self.FetchLightningWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"NA") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }


            // 70 && < 80
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Clouds") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Cloudy") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Fair") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Clear") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Overcast") != nil {
            self.FetchCloudyWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Fog") != nil {
            self.FetchCloudyWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Rain") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"storm") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"hurricane") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"showers") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Thunderstorm") != nil {
            self.FetchLightningWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"NA") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }

            // 80 && < 90
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Clouds") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Cloudy") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Fair") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Clear") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Overcast") != nil {
            self.FetchCloudyWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Fog") != nil {
            self.FetchCloudyWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Rain") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"storm") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"hurricane") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"showers") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Thunderstorm") != nil {
            self.FetchLightningWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"NA") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }


            // > 90
        else if theValue! >= 90 && theCondition.range(of:"Clouds") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 90 && theCondition.range(of:"Cloudy") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 90 && theCondition.range(of:"Fair") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 90 && theCondition.range(of:"Clear") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 90 && theCondition.range(of:"Overcast") != nil {
            self.FetchCloudyWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 90 && theCondition.range(of:"Fog") != nil {
            self.FetchCloudyWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 90 && theCondition.range(of:"Rain") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 90 && theCondition.range(of:"storm") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 90 && theCondition.range(of:"hurricane") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 90 && theCondition.range(of:"showers") != nil {
            self.FetchRainWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 90 && theCondition.range(of:"Thunderstorm") != nil {
            self.FetchLightningWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 90 && theCondition.range(of:"NA") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
        else if theValue! >= 90 && theCondition.range(of:"") != nil {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }

        else {
            self.FetchNiceWeatherCustomAlbumPhotos()
        }
    }

//    typealias CompletionHandler = (_ success:Bool) -> Void
    
    //PANDA IMAGE FETCH
    func getPandaImage(temperature: String, condition: String) {
        
        //NICE
        var coreNiceImages = fetchCoreImage("active", "nice")
        let randomNiceImage = Int(arc4random_uniform(UInt32(coreNiceImages!.count)))
        
        //CLOUDY
        var coreCloudyImages = fetchCoreImage("active", "cloudy")
        let randomCloudyImage = Int(arc4random_uniform(UInt32(coreCloudyImages!.count)))
        
        //COLD
        var coreColdImages = fetchCoreImage("active", "cold")
        let randomColdImage = Int(arc4random_uniform(UInt32(coreColdImages!.count)))
        
        //RAIN
        var coreRainImages = fetchCoreImage("active", "rain")
        let randomRainImage = Int(arc4random_uniform(UInt32(coreRainImages!.count)))
        
        //LIGHTNING
        var coreLightningImages = fetchCoreImage("active", "lightning")
        let randomLightningImage = Int(arc4random_uniform(UInt32(coreLightningImages!.count)))
        
        //SNOW
        var coreSnowImages = fetchCoreImage("active", "snow")
        let randomSnowImages = Int(arc4random_uniform(UInt32(coreSnowImages!.count)))
        
        //should change these to switch 'condition' { case '': statement case '': statement }
        
        //getPandaImage func input Strings
        let theValue = Double(temperature)
        let theCondition = condition
        
        print("theValue: " + "\(String(describing: theValue))")
        print("condition: " + "\(theCondition)")
        
        //this is really bad code. should put the else statement in the fetch, so can remove here.
        // Temperature is nil
        if theValue == nil {
            if coreColdImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreColdImages?[randomColdImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreColdImages?[randomColdImage].value(forKey: "image") as? Data)!)
            } }
        
        //<32 degreesF
        else if theValue! < 32 && theCondition.range(of:"Clouds") != nil {
            if coreColdImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreColdImages?[randomColdImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreColdImages?[randomColdImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! < 32 && theCondition.range(of:"Cloudy") != nil {
            if coreColdImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreColdImages?[randomColdImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreColdImages?[randomColdImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! < 32 && theCondition.range(of:"Fair") != nil {
            if coreColdImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreColdImages?[randomColdImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreColdImages?[randomColdImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! < 32 && theCondition.range(of:"Clear") != nil {
            if coreColdImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreColdImages?[randomColdImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreColdImages?[randomColdImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! < 32 && theCondition.range(of:"Overcast") != nil {
                if coreCloudyImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreCloudyImages?[randomCloudyImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreCloudyImages?[randomCloudyImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! < 32 && theCondition.range(of:"Fog") != nil {
                if coreCloudyImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreCloudyImages?[randomCloudyImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreCloudyImages?[randomCloudyImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! < 32 && theCondition.range(of:"Rain") != nil {
                if coreSnowImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreSnowImages?[randomSnowImages].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreSnowImages?[randomSnowImages].value(forKey: "image") as? Data)!)
        } }
        else if theValue! < 32 && theCondition.range(of:"storm") != nil {
                if coreSnowImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreSnowImages?[randomSnowImages].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreSnowImages?[randomSnowImages].value(forKey: "image") as? Data)!)
        } }
        else if theValue! < 32 && theCondition.range(of:"hurricane") != nil {
                if coreSnowImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreSnowImages?[randomSnowImages].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreSnowImages?[randomSnowImages].value(forKey: "image") as? Data)!)
        } }
        else if theValue! < 32 && theCondition.range(of:"Snow") != nil {
                if coreSnowImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreSnowImages?[randomSnowImages].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreSnowImages?[randomSnowImages].value(forKey: "image") as? Data)!)
        } }
        else if theValue! < 32 && theCondition.range(of: "NA") != nil {
                if coreSnowImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreSnowImages?[randomSnowImages].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreSnowImages?[randomSnowImages].value(forKey: "image") as? Data)!)
        } }
        else if theValue! < 32 && theCondition.range(of: "") != nil {
                if coreSnowImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreSnowImages?[randomSnowImages].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreSnowImages?[randomSnowImages].value(forKey: "image") as? Data)!)
        } }
            
        // 32 && < 50
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Clouds") != nil {
            if coreColdImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreColdImages?[randomColdImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreColdImages?[randomColdImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Cloudy") != nil {
            if coreColdImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreColdImages?[randomColdImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreColdImages?[randomColdImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Fair") != nil {
            if coreColdImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreColdImages?[randomColdImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreColdImages?[randomColdImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Clear") != nil {
            if coreNiceImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Overcast") != nil {
                if coreCloudyImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreCloudyImages?[randomCloudyImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreCloudyImages?[randomCloudyImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Fog") != nil {
                if coreCloudyImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreCloudyImages?[randomCloudyImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreCloudyImages?[randomCloudyImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Rain") != nil {
                if coreRainImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"storm") != nil {
                if coreRainImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"hurricane") != nil {
                if coreRainImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"showers") != nil {
                if coreRainImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"Thunderstorm") != nil {
                if coreLightningImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreLightningImages?[randomLightningImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreLightningImages?[randomLightningImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"NA") != nil {
            if coreColdImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreColdImages?[randomColdImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreColdImages?[randomColdImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 32 && theValue! < 50 && theCondition.range(of:"") != nil {
            if coreColdImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreColdImages?[randomColdImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreColdImages?[randomColdImage].value(forKey: "image") as? Data)!)
        } }
        
        // 50 && < 70
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Clouds") != nil {
                if coreNiceImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Cloudy") != nil {
                if coreNiceImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Fair") != nil {
                if coreNiceImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Clear") != nil {
                    if coreNiceImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Overcast") != nil {
                    if coreCloudyImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreCloudyImages?[randomCloudyImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreCloudyImages?[randomCloudyImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Fog") != nil {
                    if coreCloudyImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreCloudyImages?[randomCloudyImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreCloudyImages?[randomCloudyImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Rain") != nil {
                    if coreRainImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"storm") != nil {
                    if coreRainImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"hurricane") != nil {
                    if coreRainImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"showers") != nil {
                    if coreRainImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"Thunderstorm") != nil {
                    if coreLightningImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreLightningImages?[randomLightningImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreLightningImages?[randomLightningImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"NA") != nil {
                    if coreNiceImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 50 && theValue! < 70 && theCondition.range(of:"") != nil {
                    if coreNiceImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
        } }

            
        // 70 && < 80
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Clouds") != nil {
                if coreNiceImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Cloudy") != nil {
                if coreNiceImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Fair") != nil {
                    if coreNiceImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Clear") != nil {
                    if coreNiceImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Overcast") != nil {
                    if coreCloudyImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreCloudyImages?[randomCloudyImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreCloudyImages?[randomCloudyImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Fog") != nil {
                    if coreCloudyImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreCloudyImages?[randomCloudyImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreCloudyImages?[randomCloudyImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Rain") != nil {
                    if coreRainImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"storm") != nil {
                    if coreRainImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"hurricane") != nil {
                    if coreRainImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"showers") != nil {
                    if coreRainImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"Thunderstorm") != nil {
                    if coreLightningImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreLightningImages?[randomLightningImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreLightningImages?[randomLightningImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"NA") != nil {
                    if coreNiceImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
        } }
        else if theValue! >= 70 && theValue! < 80 && theCondition.range(of:"") != nil {
                    if coreNiceImages?.count == 0
        { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
            dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
        } }
            
        // 80 && < 90
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Clouds") != nil {
                if coreNiceImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Cloudy") != nil {
                if coreNiceImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Fair") != nil {
                if coreNiceImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Clear") != nil {
                if coreNiceImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Overcast") != nil {
                if coreCloudyImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreCloudyImages?[randomCloudyImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreCloudyImages?[randomCloudyImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Fog") != nil {
                if coreCloudyImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreCloudyImages?[randomCloudyImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreCloudyImages?[randomCloudyImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Rain") != nil {
                if coreRainImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"storm") != nil {
                if coreRainImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"hurricane") != nil {
                if coreRainImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"showers") != nil {
                if coreRainImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"Thunderstorm") != nil {
                if coreLightningImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreLightningImages?[randomLightningImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreLightningImages?[randomLightningImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"NA") != nil {
                if coreNiceImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 80 && theValue! < 90 && theCondition.range(of:"") != nil {
                if coreNiceImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
            } }
            
            
        // > 90
        else if theValue! >= 90 && theCondition.range(of:"Clouds") != nil {
            if coreNiceImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 90 && theCondition.range(of:"Cloudy") != nil {
            if coreNiceImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 90 && theCondition.range(of:"Fair") != nil {
            if coreNiceImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 90 && theCondition.range(of:"Clear") != nil {
            if coreNiceImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 90 && theCondition.range(of:"Overcast") != nil {
            if coreCloudyImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreCloudyImages?[randomCloudyImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreCloudyImages?[randomCloudyImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 90 && theCondition.range(of:"Fog") != nil {
            if coreCloudyImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreCloudyImages?[randomCloudyImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreCloudyImages?[randomCloudyImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 90 && theCondition.range(of:"Rain") != nil {
            if coreRainImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 90 && theCondition.range(of:"storm") != nil {
            if coreRainImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 90 && theCondition.range(of:"hurricane") != nil {
            if coreRainImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 90 && theCondition.range(of:"showers") != nil {
            if coreRainImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreRainImages?[randomRainImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreRainImages?[randomRainImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 90 && theCondition.range(of:"Thunderstorm") != nil {
            if coreLightningImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreLightningImages?[randomLightningImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreLightningImages?[randomLightningImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 90 && theCondition.range(of:"NA") != nil {
            if coreNiceImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
            } }
        else if theValue! >= 90 && theCondition.range(of:"") != nil {
            if coreNiceImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
            } }
        
        else {
            if coreNiceImages?.count == 0
            { dogImageView.image = #imageLiteral(resourceName: "smiling") } else if (coreNiceImages?[randomNiceImage].value(forKey: "image")) != nil {
                dogImageView.image = UIImage(data: (coreNiceImages?[randomNiceImage].value(forKey: "image") as? Data)!)
            } }
        }
    

    //FOR WEATHER RELOAD BUTTON PANDA
    func getPandaTemperature() {
        print("first")
        
        let location:CLLocationCoordinate2D = locationManager.location!.coordinate
        let lat = String(location.latitude)
        let long = String(location.longitude)
        let weatherURL = NSURL(string: "http://forecast.weather.gov/MapClick.php?lat=\(lat)&lon=\(long)&unit=0&lg=english&FcstType=json&TextType=1")
        let weatherData = try? Data(contentsOf: weatherURL! as URL)
        
        do {
            if let json = try JSONSerialization.jsonObject(with: weatherData!, options:.allowFragments) as? [String:Any] {
                print(json as Any)
                
                let defaults = UserDefaults()
                
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
//                let city = json["productionCenter"] as! String
                cityLabel.text! = city
                print("city: \(city)")
            
                let forecast = json["data"] as! [String:Any]?
                let weatherDescription: NSArray = forecast!["text"] as! NSArray
                print("\(weatherDescription[0])")
                weatherLabel.text! = weatherDescription[0] as! String
                
                //save to userdefaults for weather details
                let myData = NSKeyedArchiver.archivedData(withRootObject: forecast!)
                defaults.set(myData, forKey: "data")

                //continue...
            
                self.getPandaImage(temperature: temp, condition: condition)
                self.getWeatherIcon(theImageView: self.weatherImageView, theCondition: condition)
                
                //7-day forecast, day 1 Date, Weather Icon, and High/Low Temp
                let sevenDayDate = json["time"] as! [String:Any]?
                let sevenDayDateDescription: NSArray = sevenDayDate!["startPeriodName"] as! NSArray
                print("\(sevenDayDateDescription[1])")
                print("\(sevenDayDateDescription[12])")
                    
                //set userdefaults for day details
                let myDataDays = NSKeyedArchiver.archivedData(withRootObject: sevenDayDate!)
                defaults.set(myDataDays, forKey: "days")
                //continue...
                
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
                
                    //NOT NEEDED, SINCE IMAGE CALLED EARLIER ALREADY
                //Setting the temperature for input string in func getPandaImage
//                let sevenDayOneWeekTempZero: String = sevenDayTempDescription[0] as! String
//                let sevenDayTwoWeekTempOne: String = sevenDayTempDescription[1] as! String
//                let sevenDayThreeWeekTempTwo: String = sevenDayTempDescription[2] as! String
//                let sevenDayFourWeekTempThree: String = sevenDayTempDescription[3] as! String
//                let sevenDayFiveWeekTempFour: String = sevenDayTempDescription[4] as! String
//                let sevenDaySixWeekTempFive: String = sevenDayTempDescription[5] as! String
//                let sevenDaySevenWeekTempSix: String = sevenDayTempDescription[6] as! String
                
                //Setting the condition for input string in func getWeatherIcon and getPandaImage
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
                
//                self.getPandaImage(temperature: sevenDayOneWeekTempZero, condition: sevenDayOneConditionDescriptionZero)
                self.getWeatherIcon(theImageView: sevenDayWeatherImageView, theCondition: sevenDayOneConditionDescriptionZero)
                
//                self.getPandaImage(temperature: sevenDayTwoWeekTempOne, condition: sevenDayTwoConditionDescriptionOne)
                self.getWeatherIcon(theImageView: sevenDayTwoWeatherImageView, theCondition: sevenDayTwoConditionDescriptionOne)
                
//                self.getPandaImage(temperature: sevenDayThreeWeekTempTwo, condition: sevenDayThreeConditionDescriptionTwo)
                self.getWeatherIcon(theImageView: sevenDayThreeWeatherImageView, theCondition: sevenDayThreeConditionDescriptionTwo)
                
//                self.getPandaImage(temperature: sevenDayFourWeekTempThree, condition: sevenDayFourConditionDescriptionThree)
                self.getWeatherIcon(theImageView: sevenDayFourWeatherImageView, theCondition: sevenDayFourConditionDescriptionThree)
                
//                self.getPandaImage(temperature: sevenDayFiveWeekTempFour, condition: sevenDayFiveConditionDescriptionFour)
                self.getWeatherIcon(theImageView: sevenDayFiveWeatherImageView, theCondition: sevenDayFiveConditionDescriptionFour)
                
//                self.getPandaImage(temperature: sevenDaySixWeekTempFive, condition: sevenDaySixConditionDescriptionFive)
                self.getWeatherIcon(theImageView: sevenDaySixWeatherImageView, theCondition: sevenDaySixConditionDescriptionFive)
                
//                self.getPandaImage(temperature: sevenDaySevenWeekTempSix, condition: sevenDaySevenConditionDescriptionSix)
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
    
    //FOR SEARCH BAR BUTTON
    //forward geocoding function
    func forwardGeocodingPanda(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                //need to add an error message
                print(error!)
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
                            
                        
                        let myLocation = json["location"] as! [String:Any]?
                        let city: String = myLocation?["areaDescription"] as! String
//                        let city = json["productionCenter"] as! String //location, areaDescription
                        self.cityLabel.text! = city
                        print("city: \(city)")
                        
                        let forecast = json["data"] as! [String:Any]?
                        let weatherDescription: NSArray = forecast!["text"] as! NSArray
                        print("\(weatherDescription[0])")
                        self.weatherLabel.text! = weatherDescription[0] as! String
                        
                        self.getPandaImage(temperature: temp, condition: condition)
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
                        
                            //NOT NEEDED, SINCE IMAGE CALLED EARLIER IN FUNC
                        //Setting the temperature for input string in func getPandaImage
//                        let sevenDayOneWeekTempZero: String = sevenDayTempDescription[0] as! String
//                        let sevenDayTwoWeekTempOne: String = sevenDayTempDescription[1] as! String
//                        let sevenDayThreeWeekTempTwo: String = sevenDayTempDescription[2] as! String
//                        let sevenDayFourWeekTempThree: String = sevenDayTempDescription[3] as! String
//                        let sevenDayFiveWeekTempFour: String = sevenDayTempDescription[4] as! String
//                        let sevenDaySixWeekTempFive: String = sevenDayTempDescription[5] as! String
//                        let sevenDaySevenWeekTempSix: String = sevenDayTempDescription[6] as! String
                        
                        //Setting the condition for input string in func getWeatherIcon and getPandaImage
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
                        
//                        self.getPandaImage(temperature: sevenDayOneWeekTempZero, condition: sevenDayOneConditionDescriptionZero)
                        self.getWeatherIcon(theImageView: self.sevenDayWeatherImageView, theCondition: sevenDayOneConditionDescriptionZero)
                        
//                        self.getPandaImage(temperature: sevenDayTwoWeekTempOne, condition: sevenDayTwoConditionDescriptionOne)
                        self.getWeatherIcon(theImageView: self.sevenDayTwoWeatherImageView, theCondition: sevenDayTwoConditionDescriptionOne)
                        
//                        self.getPandaImage(temperature: sevenDayThreeWeekTempTwo, condition: sevenDayThreeConditionDescriptionTwo)
                        self.getWeatherIcon(theImageView: self.sevenDayThreeWeatherImageView, theCondition: sevenDayThreeConditionDescriptionTwo)
                        
//                        self.getPandaImage(temperature: sevenDayFourWeekTempThree, condition: sevenDayFourConditionDescriptionThree)
                        self.getWeatherIcon(theImageView: self.sevenDayFourWeatherImageView, theCondition: sevenDayFourConditionDescriptionThree)
                        
//                        self.getPandaImage(temperature: sevenDayFiveWeekTempFour, condition: sevenDayFiveConditionDescriptionFour)
                        self.getWeatherIcon(theImageView: self.sevenDayFiveWeatherImageView, theCondition: sevenDayFiveConditionDescriptionFour)
                        
//                        self.getPandaImage(temperature: sevenDaySixWeekTempFive, condition: sevenDaySixConditionDescriptionFive)
                        self.getWeatherIcon(theImageView: self.sevenDaySixWeatherImageView, theCondition: sevenDaySixConditionDescriptionFive)
                        
//                        self.getPandaImage(temperature: sevenDaySevenWeekTempSix, condition: sevenDaySevenConditionDescriptionSix)
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
    
    //FOR WEATHER RELOAD BUTTON
    func getUserTemperature() {
        print("first")
        
        let location:CLLocationCoordinate2D = locationManager.location!.coordinate
        let lat = String(location.latitude)
        let long = String(location.longitude)
        let weatherURL = NSURL(string: "http://forecast.weather.gov/MapClick.php?lat=\(lat)&lon=\(long)&unit=0&lg=english&FcstType=json&TextType=1")
        let weatherData = try? Data(contentsOf: weatherURL! as URL)
        
        do {
            if let json = try JSONSerialization.jsonObject(with: weatherData!, options:.allowFragments) as? [String:Any] {
                print(json as Any)
                
                let defaults = UserDefaults()
                
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
                    
                    //set userdefaults for weather details
                    let myData = NSKeyedArchiver.archivedData(withRootObject: forecast!)
                    defaults.set(myData, forKey: "data")
                
                    //continue...
                    
                    self.getUserImage(temperature: temp, condition: condition)
                    self.getWeatherIcon(theImageView: self.weatherImageView, theCondition: condition)
                    
                    //7-day forecast, day 1 Date, Weather Icon, and High/Low Temp
                    let sevenDayDate = json["time"] as! [String:Any]?
                    let sevenDayDateDescription: NSArray = sevenDayDate!["startPeriodName"] as! NSArray
                    print("\(sevenDayDateDescription[1])")
                    print("\(sevenDayDateDescription[12])")
                    
                    //set userdefaults for day details
                    let myDataDays = NSKeyedArchiver.archivedData(withRootObject: sevenDayDate!)
                    defaults.set(myDataDays, forKey: "days")
                    //continue...
                    
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
                    
                                                //NOT NEEDED, SINCE IMAGE CALLED EARLIER IN FUNC
                    //Setting the temperature for input string in func getWeatherIcon and getUserImage
//                    let sevenDayOneWeekTempZero: String = sevenDayTempDescription[0] as! String
//                    let sevenDayTwoWeekTempOne: String = sevenDayTempDescription[1] as! String
//                    let sevenDayThreeWeekTempTwo: String = sevenDayTempDescription[2] as! String
//                    let sevenDayFourWeekTempThree: String = sevenDayTempDescription[3] as! String
//                    let sevenDayFiveWeekTempFour: String = sevenDayTempDescription[4] as! String
//                    let sevenDaySixWeekTempFive: String = sevenDayTempDescription[5] as! String
//                    let sevenDaySevenWeekTempSix: String = sevenDayTempDescription[6] as! String
                    
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
    
    //FOR SEARCH BAR BUTTON USER IMAGE
    //forward geocoding function
    func forwardGeocodingUser(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                //Error message
                print(error!)
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
                            
                            //let currentObservation = json["currentobservation"] as! [String:Any]?
                            //let state: String = currentObservation?["state"] as! String
                            //
                            //if state != nil {
                            
                            let currentObservation = json["currentobservation"] as! [String:Any]?
                            let temp: String = currentObservation?["Temp"] as! String
                            let tempDegreesF = temp + "℉"
                            self.temperatureLabel.text! = tempDegreesF
                            print("tempDegreesF: \(tempDegreesF)")
                            
                            let weatherCondition = json["currentobservation"] as! [String:Any]?
                            let condition: String = weatherCondition?["Weather"] as! String
                            self.conditionLabel.text! = condition
                            print("condition: \(condition)")
                            
                            
                            let myLocation = json["location"] as! [String:Any]?
                            let city: String = myLocation?["areaDescription"] as! String
//                            let city = json["productionCenter"] as! String //location, areaDescription
                            self.cityLabel.text! = city
                            print("city: \(city)")
                            
                            let forecast = json["data"] as! [String:Any]?
                            let weatherDescription: NSArray = forecast!["text"] as! NSArray
                            print("\(weatherDescription[0])")
                            self.weatherLabel.text! = weatherDescription[0] as! String
                            
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
                            
                                                        //NOT NEEDED, SINCE IMAGE CALLED EARLIER IN FUNC
                            //Setting the temperature for input string in func getWeatherIcon and getUserImage
//                            let sevenDayOneWeekTempZero: String = sevenDayTempDescription[0] as! String
//                            let sevenDayTwoWeekTempOne: String = sevenDayTempDescription[1] as! String
//                            let sevenDayThreeWeekTempTwo: String = sevenDayTempDescription[2] as! String
//                            let sevenDayFourWeekTempThree: String = sevenDayTempDescription[3] as! String
//                            let sevenDayFiveWeekTempFour: String = sevenDayTempDescription[4] as! String
//                            let sevenDaySixWeekTempFive: String = sevenDayTempDescription[5] as! String
//                            let sevenDaySevenWeekTempSix: String = sevenDayTempDescription[6] as! String
                            
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
                            
//                            self.getUserImage(temperature: sevenDayOneWeekTempZero, condition: sevenDayOneConditionDescriptionZero)
                            self.getWeatherIcon(theImageView: self.sevenDayWeatherImageView, theCondition: sevenDayOneConditionDescriptionZero)
                            
//                            self.getUserImage(temperature: sevenDayTwoWeekTempOne, condition: sevenDayTwoConditionDescriptionOne)
                            self.getWeatherIcon(theImageView: self.sevenDayTwoWeatherImageView, theCondition: sevenDayTwoConditionDescriptionOne)
                            
//                            self.getUserImage(temperature: sevenDayThreeWeekTempTwo, condition: sevenDayThreeConditionDescriptionTwo)
                            self.getWeatherIcon(theImageView: self.sevenDayThreeWeatherImageView, theCondition: sevenDayThreeConditionDescriptionTwo)
                            
//                            self.getUserImage(temperature: sevenDayFourWeekTempThree, condition: sevenDayFourConditionDescriptionThree)
                            self.getWeatherIcon(theImageView: self.sevenDayFourWeatherImageView, theCondition: sevenDayFourConditionDescriptionThree)
                            
//                            self.getUserImage(temperature: sevenDayFiveWeekTempFour, condition: sevenDayFiveConditionDescriptionFour)
                            self.getWeatherIcon(theImageView: self.sevenDayFiveWeatherImageView, theCondition: sevenDayFiveConditionDescriptionFour)
                            
//                            self.getUserImage(temperature: sevenDaySixWeekTempFive, condition: sevenDaySixConditionDescriptionFive)
                            self.getWeatherIcon(theImageView: self.sevenDaySixWeatherImageView, theCondition: sevenDaySixConditionDescriptionFive)
                            
//                            self.getUserImage(temperature: sevenDaySevenWeekTempSix, condition: sevenDaySevenConditionDescriptionSix)
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
