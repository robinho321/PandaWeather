//
//  PandaImages.swift
//  SH Softball
//
//  Created by Casey Raymond on 10/22/17.
//  Copyright © 2017 Casey Raymond. All rights reserved.
//

import UIKit
import Foundation
import CoreData

func PandaImagesCollect(){
    let myUrl = URL(string: "http://danslacave.com/PANDA/jsonfiles/PANDAIMAGES.php");
    let request = NSMutableURLRequest(url:myUrl!);
    request.httpMethod = "POST";
    let param = [
        "User"  : "Hello",
        "date"    : "Hello"
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
                let ImageFetch:AnyObject = appDict as AnyObject
                let id: Int? = ImageFetch.value(forKey: "id") as! Int?
                let type: String? = ImageFetch.value(forKey: "type") as! String?
                let file: Int? = ImageFetch.value(forKey: "file") as! Int?
                let status: String? = ImageFetch.value(forKey: "status") as! String?
                let imagefile: String? = String(file!)+".jpg"
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
                
                panda.setValue(type, forKey: "type")
                panda.setValue(type, forKey: "active")
                
                let imagew = "http://danslacave.com/PANDA/includes/pages/image_upload/uploads/" + imagefile!
                #if UNITY_IPHONE
                    UnityEngine.iOS.Device.SetNoBackupFlag(path);
                #endif
                let url = URL(string: imagew)
                do {
                    try (url! as NSURL).setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
                } catch _{
                    print("Failed")
                }
                let data = try? Data(contentsOf: url!) //only loads if the entire webpage is just an image
                if data == nil {} else {
                    //let imagefile = UIImagePNGRepresentation(UIImage(data: data!)!)
                    if data == nil {} else {
                        let imageIndex  = imagefile?.characters.index((imagefile?.endIndex)!, offsetBy: -3)
                        let imageType:String = (imagefile?.substring(from: imageIndex!))!
                        switch imageType
                        {
                        case  "png":
                            let imagefilepng = UIImagePNGRepresentation(UIImage(data: data!)!)
                            panda.setValue(imagefilepng, forKey: "image")
                        case "jpg","peg":
                            let imagefilejpg = UIImageJPEGRepresentation(UIImage(data: data!)!, 0.8)
                            panda.setValue(imagefilejpg, forKey: "image")
                        default:
                            break;
                        }
                    }
                }
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
            
        } catch {
            print(error)
        } 
    })
    task.resume()
}

