//
//  LightningCVC.swift
//  PandaWeather
//
//  Created by Robin Allemand on 2/4/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Photos

let albumName5 = "Panda - Lightning Weather"            //App specific folder name

class LightningCVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var albumFound : Bool = false
    var assetCollection: PHAssetCollection = PHAssetCollection()
    var photosAsset: PHFetchResult<PHAsset>!
    var assetThumbnailSize:CGSize!
    var index: Int = 0
    
  
    //Actions & Outlets
    @IBOutlet weak var addMyImageButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func addMyImage(_ sender : AnyObject) {
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.delegate = self
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        //Check if the folder exists, if not, create it
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName5)
        let collection: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let first_Obj:AnyObject = collection.firstObject{
            //found the album
            self.albumFound = true
            self.assetCollection = first_Obj as! PHAssetCollection
        } else {
            //Album placeholder for the asset collection, used to reference collection in completion handler
            var albumPlaceholder: PHObjectPlaceholder!
            //create the folder
            NSLog("\nFolder \"%@\" does not exist\nCreating now...", albumName5)
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName5)
                albumPlaceholder = request.placeholderForCreatedAssetCollection
            },
               completionHandler: {(success:Bool, error:Error?) in
                if(success){
                    print("Successfully created folder")
                    self.albumFound = true
                    let collection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumPlaceholder.localIdentifier], options: nil)
                    self.assetCollection = collection.firstObject!
                } else {
                    print("Error creating folder")
                    self.albumFound = false
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Get size of the collectionView cell for thumbnail image
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            let cellSize = layout.itemSize
            self.assetThumbnailSize = CGSize(width: cellSize.width, height: cellSize.height)
        }
        
        //fetch the photos from collection
        self.navigationController?.hidesBarsOnTap = false   //!! Use optional chaining
        self.photosAsset = PHAsset.fetchAssets(in: self.assetCollection, options: nil)
        
        self.collectionView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //UICollectionViewDataSource Methods (Remove the "!" on variables in the function prototype)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        var count: Int = 0
        if(self.photosAsset != nil){
            count = self.photosAsset.count
        }
        return count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? lightningCell
        
        //Modify the cell
        let asset = self.photosAsset[indexPath.item]
        
        // Create options for retrieving image (Degrades quality if using .Fast)
        //        let imageOptions = PHImageRequestOptions()
        //        imageOptions.resizeMode = PHImageRequestOptionsResizeMode.Fast
        PHImageManager.default().requestImage(for: asset, targetSize: self.assetThumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: {(result, info) in
            if let image = result {
                cell?.setThumbnailImage(image)
                cell?.delegate = self
            }
        })
        return cell!
    }
    
    //UIImagePickerControllerDelegate Methods
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]){
        NSLog("in didFinishPickingMediaWithInfo")
        if let url: NSURL = info[UIImagePickerControllerImageURL] as? NSURL {
            
            //Implement if allowing user to edit the selected image
            
            PHPhotoLibrary.shared().performChanges({
                let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url as URL)
                let assetPlaceholder = createAssetRequest?.placeholderForCreatedAsset
                if let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection, assets: self.photosAsset) {
                    albumChangeRequest.addAssets([assetPlaceholder!] as NSArray)
                }
            }, completionHandler: {(success: Bool, error: Error?) in
                if (success) {
                    // Move to the main thread to execute
                    DispatchQueue.main.async(execute: {
                        self.photosAsset = PHAsset.fetchAssets(in: self.assetCollection, options: nil)
                        if self.photosAsset.count == 0 {
                            print("No Images Left!!")
                            self.collectionView.reloadData()
                            picker.dismiss(animated: true, completion: nil)
                        } else {
                            print("\(self.photosAsset.count) image/s left")
                            self.collectionView.reloadData()
                            picker.dismiss(animated: true, completion: nil)
                        }
                    })
                } else {
                    print("Error: \(String(describing: error))")
                    picker.dismiss(animated: true, completion: nil)
                    
                }
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Mark - Delete Items
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        addMyImageButton.isEnabled = !editing
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                if let cell = collectionView?.cellForItem(at: indexPath) as? lightningCell {
                    cell.isEditing = editing
                }
            }
        }
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized: break
            
        //handle authorized status
        case .denied, .restricted : break
        //handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized: break
                // as above
                case .denied, .restricted: break
                // as above
                case .notDetermined: break
                    // won't happen but still
                }
            }
        }
    }
}

extension LightningCVC: lightningCellDelegate
{
    func delete(cell: lightningCell) {
        if var indexPath = collectionView?.indexPath(for: cell) {
            //1. delete the photo from our data source
            PHPhotoLibrary.shared().performChanges({
                //Delete Photo
                if let request = PHAssetCollectionChangeRequest(for: self.assetCollection){
                    request.removeAssets(at: IndexSet([indexPath.item]))
                }
            }, completionHandler: {(success: Bool, error: Error?) in
                if (success) {
                    // Move to the main thread to execute
                    DispatchQueue.main.async(execute: {
                        self.photosAsset = PHAsset.fetchAssets(in: self.assetCollection, options: nil)
                        if self.photosAsset.count == 0 {
                            print("No Images Left!!")
                            self.collectionView.reloadData()
                            //if let navController = self.navigationController {
                            //navController.popToRootViewController(animated: true)
                            //}
                        } else {
                            print("\(self.photosAsset.count) image/s left")
                            if indexPath.item >= self.photosAsset.count {
                                indexPath.item = self.photosAsset.count - 1
                                self.collectionView.reloadData()
                            }
                        }
                    })
                } else {
                    print("Error: \(String(describing: error))")
                }
            })
            
            
            //2. delete the photo cell at that index path from the collection view
            //                self.collectionView?.deleteItems(at: [indexPath])
            //                self.collectionView.reloadData()
        }
    }
}

