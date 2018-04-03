//
//  AdminImageTableViewController.swift
//  PandaWeather
//
//  Created by Robin Allemand on 11/19/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import CoreData

class AdminImageTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    @IBAction func statusSwitch(_ sender: UISwitch) {

            //Create Account
            let UpdateUserURL = "http://danslacave.com/PANDA/jsonfiles/deactivateImage.php"
            let request = NSMutableURLRequest(url: URL(string: UpdateUserURL)!)
            request.httpMethod = "POST"
    
            let buttonRow = sender.tag
            let indexPath = IndexPath(row: buttonRow, section: 0)
            let dataRow = fetchedResultsController.object(at: indexPath)
            let imageId = (dataRow.value(forKey: "id")as? Int)!
            let id:String = String(imageId)
        
            let param = [
                "id" : id
                ]
            let boundary = generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = createBodyWithParameters(param, boundary: boundary)

            //spinningWheel.startAnimating();
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
                data, response, error in
                
                if error != nil {
                    print("error=\(String(describing: error))")
                    return
                }
                
                // You can print out response object
                print("******* response = \(String(describing: response))")
                
                // Print out reponse body
                _ = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                print("****** response data = \(responseString!)")
                
                                        let json = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray
                                        for appDict in json! {
                
                                            let appDict = json![0] as AnyObject
                                            let stid: String? = (appDict as AnyObject).value(forKey: "type") as? String
                                            if stid != nil {
                                                //Fetch data
                                                let ImageFetch:AnyObject = appDict as AnyObject
                                                let id: Int? = ImageFetch.value(forKey: "id") as! Int?
                                                let status: String? = ImageFetch.value(forKey: "status") as! String?
                                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                let managedContext = appDelegate.managedObjectContext!
                                                let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                                                privateMOC.parent = managedContext
                                                //Filter the data
                                                let request = NSFetchRequest<PandaImage>(entityName: "PandaImage")
                                                
                                                request.returnsObjectsAsFaults = false;
                                                let resultPredicate1 = NSPredicate(format: "id = %i", id!)
                                                let compound = NSCompoundPredicate(andPredicateWithSubpredicates:[resultPredicate1])
                                                request.predicate = compound
                                                var error: NSError?
                                                
                                                let fetchedResult:NSArray = try! managedContext.fetch(request) as NSArray
                                                
                                                var panda:PandaImage
                                                if fetchedResult.count > 0 {
                                                    panda = (fetchedResult[0] as AnyObject) as! PandaImage
                                                } else {
                                                    let entity =  NSEntityDescription.entity(forEntityName: "PandaImage", in: managedContext)
                                                    panda = (NSManagedObject(entity: entity!, insertInto:managedContext) as AnyObject) as! PandaImage
                                                    panda.setValue(id, forKey: "id")
                                                }
                                                
                                                panda.setValue(status, forKey: "active")
                                                
                                                
                                                do {
                                                    try privateMOC.save()
                                                    //Update Field -- need to make this reload just photos with latest time stamp
                                                    DispatchQueue.main.async(execute: {
                                                        self.tableView.reloadData()
                                                        
                                                        //Add button for success
                                                        let alert = UIAlertController(title: "Success", message: "Status has been updated on the server!", preferredStyle: .alert)
                                                        
                                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
                                                        }))
                                                        
                                                        self.present(alert, animated: true, completion: nil)
                                                    });
                                                    
                                                } catch let error1 as NSError {
                                                    error = error1
                                                    print("Could not save \(String(describing: error)), \(String(describing: error?.userInfo))")
                                                }
                //                                String Success = "Yes"
                                                //If your app goes here you are setup correctly
                                                //we will populate this later
                                            }else {
                                                
                                                //Update Field
                                                DispatchQueue.main.async(execute: {
                                                    self.tableView.reloadData()
                                                    
                                                    //Add button to say it failed -- not working...
                                                    let alert = UIAlertController(title: "Error", message: "Status failed to update on the server!", preferredStyle: .alert)
                                                    
                                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
                                                    }))
                                                    
                                                    self.present(alert, animated: true, completion: nil)
                                                    
                                                });
                                            }
                                        }
            })
            task.resume()
        }
    
    @IBAction func deleteImageButton(_ sender: UIButton) {
        //Tell server to delete the image, remove the row, update the tableview.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 150
        } else {
        return 150
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
                as! ImageCell
            let indexPaths = indexPath.row
            cell.switchLabel.tag = indexPaths
            let team = fetchedResultsController.object(at: indexPath)
            cell.WeatherTypeLabel.text = team.value(forKey: "type") as? String
            if (team.value(forKey: "active") as? String == "active")
            {
            cell.switchLabel.isOn = true
            }
            else {
                cell.switchLabel.isOn = false
            }
            if (team.value(forKey: "image") != nil)
            {
                cell.PandaImage.image = UIImage(data: (team.value(forKey: "image") as? Data)!)
            }
            return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//        let team = fetchedResultsController.object(at: indexPath)
//        TeamSelectedRow = (team.value(forKey: "id") as? Int)!
        
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        TeamSelectedRow = 0
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
        }
        self.tableView.reloadData()
        
//        DispatchQueue.main.async(execute: {
//            NotificationCenter.default.post(name: Notification.Name(rawValue: "passwordUpdated"), object: nil, userInfo: nil)
//        });
        
    }
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<PandaImage> in
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        let FetchRequest = NSFetchRequest<PandaImage>(entityName: "PandaImage")
        let primarySortDescriptor = NSSortDescriptor(key: "type", ascending: true)
//        let resultPredicate1 = NSPredicate(format: "active = %@", "active")
//        let compound = NSCompoundPredicate(andPredicateWithSubpredicates:[resultPredicate1])
//        FetchRequest.predicate = compound
        FetchRequest.sortDescriptors = [primarySortDescriptor]
        let frc = NSFetchedResultsController(
            fetchRequest: FetchRequest,
            managedObjectContext: moc!,
            sectionNameKeyPath: "fake",
            cacheName: nil)
        return frc
    }()
    
    
    func createBodyWithParameters(_ parameters: [String: String]?, boundary: String) -> Data {
        let body = NSMutableData();
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        
        return body as Data
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
}
