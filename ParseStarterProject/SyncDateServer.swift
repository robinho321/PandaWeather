//
//  SyncDateServer.swift
//  PandaWeather
//
//  Created by Robin Allemand on 12/31/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Foundation
import CoreData

func syncDateCollect(){
    let myUrl = URL(string: "http://danslacave.com/PANDA/jsonfiles/syncDateCollect.php");
    let request = NSMutableURLRequest(url:myUrl!);
    request.httpMethod = "POST";
    let param = [
        "User"  : "Hello",
        "date"  : "Hello"
    ]
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
    
    let boundary = generateBoundaryString()
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpBody = createBodyWithParameters(param, boundary: boundary)
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
        //print("****** response data = \(responseString!)")
        
        //var err: NSError?
        
        var json: NSArray!
        do {
            json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? NSArray
            for appDict in json {
                //Fetch data
                let DateFetch:NSDate = appDict as! NSDate
                let currentdate: NSDate? = DateFetch.value(forKey: "currentdate") as! NSDate?
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext!
                let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateMOC.parent = managedContext
                //Filter the data
                let request = NSFetchRequest<SyncDate>(entityName: "SyncDate")
                
                request.returnsObjectsAsFaults = false;
                let resultPredicate1 = NSPredicate(format: "currentdate = %@", currentdate!)
                let compound = NSCompoundPredicate(andPredicateWithSubpredicates:[resultPredicate1])
                request.predicate = compound
                var error: NSError?
                
                
                let fetchedResult:NSArray = try! managedContext.fetch(request) as NSArray
                
                var date:SyncDate
                if fetchedResult.count > 0 {
                    date = (fetchedResult[0] as AnyObject) as! SyncDate
                } else {
                    let entity =  NSEntityDescription.entity(forEntityName: "SyncDate", in: managedContext)
                    date = (NSManagedObject(entity: entity!, insertInto:managedContext) as AnyObject) as! SyncDate
                    date.setValue(currentdate, forKey: "currentdate")
                }
                
//                panda.setValue(type, forKey: "type")
//                panda.setValue(status, forKey: "active")
                
                do {
                    try privateMOC.save()
                    //Update Field
                    DispatchQueue.main.async(execute: {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateNews"), object: nil, userInfo: nil)
                    });
                } catch let error1 as NSError {
                    error = error1
                    print("Could not save \(String(describing: error)), \(String(describing: error?.userInfo))")
                }
            }
            //Finishes sending date to server
            
            //Loads the Main View Controller
            DispatchQueue.main.async(execute: {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "timesUpdated"), object: nil, userInfo: nil)
            });
            
        } catch {
            print(error)
        }
    })
    task.resume()
}

