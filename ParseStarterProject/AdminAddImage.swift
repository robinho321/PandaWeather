//
//  AdminAddImage.Swift
//  PandaWeather
//
//  Created by Robin Allemand on 12/16/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import MapKit
import UIKit
import Parse
import CoreLocation
import AddressBookUI
import CoreData
import QuartzCore

class AdminAddImage: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate  {

    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var PandaImage: UIImageView!
    var UploadImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func ImageSelectButton(_ sender: AnyObject) {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate;
                myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(myPickerController, animated: true,completion: nil)
            }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
//                let IMAGEResize = resizeImage(image: (info[UIImagePickerControllerOriginalImage] as? UIImage)!,newWidth: 204)
                let image = info[UIImagePickerControllerOriginalImage] as? UIImage
                PandaImage.image = image
                UploadImage = "Yes"
                self.dismiss(animated: true, completion: nil)
            }

    
    //server interaction - image upload
    @IBAction func request(_ sender: AnyObject) {
                //errorLog.text = ""
                if type.text == ""{
                    type.placeholder = "Information missing"
                    //errorLog.text = "Missing Name"
                } else if UploadImage == "" {
                    //need to add an alert if no image
                } else {
                    //Create Account
                    let UpdateUserURL = "http://danslacave.com/PANDA/jsonfiles/addImage.php"
                    let request = NSMutableURLRequest(url: URL(string: UpdateUserURL)!)
                    request.httpMethod = "POST"
                    var PandaCore = PandaImagesCollect()
//                    $type = $_POST["type"];
                    //$file = $_POST["file"];
//                    status = $_POST["status"];
        
                    let type:String = self.type.text! //Change this to the selector value of the type
                    let status:String = "active"//We will set this by default for now
                    let param = [
                        "type" : type,
                        "status" : status,
                        ]
                    let boundary = generateBoundaryString()
                    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                    if (UploadImage=="Yes"){
                        let imageData = UIImageJPEGRepresentation(PandaImage.image!, 1)
                        if(imageData==nil)  { return; }
                        request.httpBody = createBodyWithImageParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
                    }else{
                        request.httpBody = createBodyWithParameters(param, boundary: boundary)
                    }
                    UploadImage = ""
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
                        //print("****** response data = \(responseString!)")
        
                        //
                        
//                        let json = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray
//                        for appDict in json! {
//
//                            //let appDict = json![0] as AnyObject
//                            let stid: String? = (appDict as AnyObject).value(forKey: "type") as? String
//                            if stid != nil {
////                                String Success = "Yes"
//                                //If your app goes here you are setup correctly
//                                //we will populate this later
//                            }else{
//                                DispatchQueue.main.async(execute: {
////                                    self.tableView.reloadData()
//                                });
//                            }
//                        }
                    })
                    task.resume()
                }
            }
    
    
    
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
                let scale = newWidth / image.size.width
                let newHeight = image.size.height * scale
                UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
                image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
        
                return newImage
            }

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
    
    func createBodyWithImageParameters(_ parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        let body = NSMutableData();
        
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        let filename = "1"
        let mimetype = "image/jpg"
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(String(describing: filename))\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(boundary)--\r\n")
        return body as Data
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
}
}
