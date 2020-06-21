//
//  IAPViewController.swift
//  PandaWeather
//
//  Created by Robin Allemand on 6/6/20.
//  Copyright © 2020 Parse. All rights reserved.
//

import Foundation
import UIKit
import StoreKit
import SwiftyStoreKit
import RealmSwift

protocol IAPViewControllerDelegate {
    func didCloseIAP(controller: IAPViewController)
}

var sharedSecret = "8e13b53a200e4a7cab5f9f7de05ec664"

enum RegisteredPurchase : String {
    case autoRenewableMonth = "CustomPhotoMonth"
    case autoRenewableYear = "CustomPhotoYear"
}

class NetworkActivityIndicatorManager: NSObject {
    
    private static var loadingCount = 0
    
    class func NetworkOperationStarted() {
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
    }
    class func networkOperationsFinished() {
        if loadingCount > 0 {
            loadingCount -= 1
        }
        
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}

class IAPViewController: UIViewController {
    
    var delegate: IAPViewControllerDelegate? = nil
    
    let bundleID = "robin.snowapp"
    
    let inAppPurchaseIds = [
    ["robin.snowapp.CustomPhotoMonth","robin.snowapp.CustomPhotoYear"]
    ]
    
    var autoRenewableMonth = RegisteredPurchase.autoRenewableMonth
    var autoRenewableYear = RegisteredPurchase.autoRenewableYear
   
    //Labels, imageviews, and views
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var proSubscriptionLabel: UILabel!
    @IBOutlet weak var oneClickLabel: UILabel!
    
    @IBOutlet weak var proTopView: UIView!
    @IBOutlet weak var proBottomView: UIView!
    @IBOutlet weak var standardTopView: UIView!
    @IBOutlet weak var standardBottomView: UIView!
    
    @IBOutlet weak var bottomSubscribeView: UIView!
    @IBOutlet weak var subscribeNowLabel: UILabel!
    @IBOutlet weak var threeDayTrialLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    
    @IBOutlet weak var userAgreementLabel: UILabel!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.isHidden = true
        
        self.proBottomView.layer.cornerRadius = 10
        self.proBottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        self.proTopView.layer.cornerRadius = 10
        //top two corners
        self.proTopView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
 
        self.standardBottomView.layer.cornerRadius = 10
        self.standardBottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        self.standardTopView.layer.cornerRadius = 10
        //top two corners
        self.standardTopView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        //bottom two corners
//        self.standardTopView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        self.bottomSubscribeView.layer.cornerRadius = 10
        
        self.yearButton.layer.cornerRadius = 10
        self.monthButton.layer.cornerRadius = 10
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.userAgreementLabel.text! = "Custom Photo Plus Month & Year membership can be purchased through iTunes for $0.99 per month and $2.99 per year respectively, and will be charged to the iTunes Account at confirmation of purchase. The account will be charged $0.99 or $2.99 for renewal within 24 hours prior to the end of the current period. The subscription will renew automatically unless auto-renew is turned off at least 24 hours before the end of the current membership period. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Settings, clicking on Apple ID, then Subscriptions after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable. By purchasing a membership you are agreeing to our Privacy Policy and Terms of Service."
        
        self.oneClickLabel.text! = "Just one click to use your own Custom Photos for weather backgrounds!"
        
        for i in 0...inAppPurchaseIds.count - 1 {
            for j in 0...inAppPurchaseIds[i].count - 1 {
                SwiftyStoreKit.retrieveProductsInfo([inAppPurchaseIds[i][j]]) { result in
                    if let product = result.retrievedProducts.first {
                        let priceString = product.localizedPrice!
                        print("Product: \(product.localizedDescription), price: \(priceString)")
                        
                        switch i {
                        case 0: self.verifySubscription(with: self.inAppPurchaseIds[i][j], sharedSecret: sharedSecret)
                        default:
                            print("Oops: no IAP")
                        }
                    }
                    else if let invalidProductId = result.invalidProductIDs.first {
                        print("Invalid product identifier: \(invalidProductId)")
                    }
                    else {
                        print("Error: \(String(describing: result.error))")
                    }
                }
            }
        }
        
    }
    
    //UIButtons
    @IBAction func closeButton(_ sender: Any) {
        self.delegate?.didCloseIAP(controller: self)
    }
    
    @IBAction func IAPMonthButton(_ sender: UIButton) {
        //        IAPService.shared.purchase(product: .autoRenewingSubscriptionMonth)
//        purchase(purchase: autoRenewableMonth)
        purchaseProduct(with: inAppPurchaseIds[0][0])
        
    }
    
    @IBAction func IAPYearButton(_ sender: UIButton) {
//        IAPService.shared.purchase(product: .autoRenewingSubscriptionYear)
//        purchase(purchase: autoRenewableYear)
        purchaseProduct(with: inAppPurchaseIds[0][1])

    }
    
    @IBAction func termsAndConditionsButton(_ sender: UIButton) {
        if let url = URL(string: "https://www.termsfeed.com/privacy-policy/745ae9e49fce9a2651d9f39ac6d035cf") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func restoreButton(_ sender: UIButton) {
        self.restorePurchases()
    }
    
    
//    func getInfo(purchase : RegisteredPurchase) {
//        NetworkActivityIndicatorManager.NetworkOperationStarted()
//        SwiftyStoreKit.retrieveProductsInfo([bundleID + "." + purchase.rawValue], completion: {
//            result in
//            NetworkActivityIndicatorManager.networkOperationsFinished()
//
//            self.showAlert(alert: self.alertForProductRetrievalInfo(result: result))
//
//        })
//    }
    
    func verifySubscription(with id: String, sharedSecret: String) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = id
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: id,
                    inReceipt: receipt)
                    
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                case .expired(let expiryDate, let items):
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }

            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    func purchaseProduct(with id: String) {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        
        SwiftyStoreKit.retrieveProductsInfo([id]) { result in
            if let product = result.retrievedProducts.first {
                SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
                    
                    switch result {
                        
                    case .success(let product):
                        
                        UserDefaults.standard.set("true", forKey: "hasSubscription")
                        print("Saved in USD: purchased, dog!")
                        
                        // fetch content from your server, then:
                        if product.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(product.transaction)
                        }

                        print("Purchase Success: \(product.productId)")
                        self.showAlert(alert: self.alertForPurchaseResult(result: result))
                        
                        self.activityIndicatorView.isHidden = true
                        self.activityIndicatorView.stopAnimating()
                        
                    case .error(let error):
                        switch error.code {
                        case .unknown: print("Unknown error. Please contact support")
                        case .clientInvalid: print("Not allowed to make the payment")
                        case .paymentCancelled: break
                        case .paymentInvalid: print("The purchase identifier was invalid")
                        case .paymentNotAllowed: print("The device is not allowed to make the payment")
                        case .storeProductNotAvailable: print("The product is not available in the current storefront")
                        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                        default: print((error as NSError).localizedDescription)
                        }
                        
                        self.activityIndicatorView.isHidden = true
                        self.activityIndicatorView.stopAnimating()
                        
                        self.showAlert(alert: self.alertForPurchaseResult(result: result))
                    }
                }
            }
        }
    
    }
        
    func restorePurchases() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                self.showAlert(alert: self.alertForRestorePurchases(result: results))
                
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()

            }
            else if results.restoredPurchases.count > 0 {
                UserDefaults.standard.set("true", forKey: "hasSubscription")
                print("Saved in USD: purchased, dog!")
                print("Restore Success: \(results.restoredPurchases)")
                self.showAlert(alert: self.alertForRestorePurchases(result: results))
                
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()

            }
            else {
                print("Nothing to Restore")
                self.showAlert(alert: self.alertForRestorePurchases(result: results))
                
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()

            }
            
        }
        
    }
    func verifyReceipt() {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationsFinished()
            
            self.showAlert(alert: self.alertForVerifyReceipt(result: result))
            
            if case .error(let error) = result {
                if case .noReceiptData = error {
                    self.verifyReceipt()
                    
                }
            }
            
        })
        
    }
    
    func verifyPurchase(with id: String, sharedSecret: String) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = id
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                    
                switch purchaseResult {
                case .purchased(let receiptItem):
                    print("\(productId) is purchased: \(receiptItem)")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
}

extension IAPViewController {
    
    func alertWithTitle(title : String, message : String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
        
    }
    
    func showAlert(alert : UIAlertController) {
        guard let _ = self.presentedViewController else {
        self.present(alert, animated: true, completion: nil)
            return
        }
    }
    func alertForProductRetrievalInfo(result : RetrieveResults) -> UIAlertController {
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            return alertWithTitle(title: product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
        }
        else if let invalidProductID = result.invalidProductIDs.first {
            return alertWithTitle(title: "Could not retrieve product info", message: "Invalid product identifier: \(invalidProductID)")
        }
        else {
            let errorString = result.error?.localizedDescription ?? "Unknown Error. Please Contact Support"
            return alertWithTitle(title: "Could not retrieve product info", message: errorString)
        }
    }
    func alertForPurchaseResult(result : PurchaseResult) -> UIAlertController {
        switch result {
            case .success(let product):
                print("Purchase Successful: \(product.productId)")
                return alertWithTitle(title: "Thank You", message: "Purchase completed. Close the Pro Subscription view to return to the previous screen, and click on Customize Your Photos to start adding custom images!")
            
            case .error(let error):
                print("Purchase Failed: \(error)")
                switch error.code {
                case .unknown:
                    return alertWithTitle(title: "Purchase Failed", message: "Unknown Error. Please Contact Support")
                case .clientInvalid:
                    return alertWithTitle(title: "Purchase Failed", message: "Not allowed to make the payment")
                case .paymentInvalid:
                    return alertWithTitle(title: "Purchase Failed", message: "The purchase identifier was invalid")
                case .paymentNotAllowed:
                    return alertWithTitle(title: "Purchase Failed", message: "The device is not allowed to make the payment")
                case .storeProductNotAvailable:
                    return alertWithTitle(title: "Purchase Failed", message: "The product is not available in the current storefront")
                case .cloudServicePermissionDenied:
                    return alertWithTitle(title: "Purchase Failed", message: "Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed:
                    return alertWithTitle(title: "Purcahse Failed", message: "Could not connect to the network")
                case .cloudServiceRevoked:
                    return alertWithTitle(title: "Purchase Failed", message: "Could not connect to the network")
                case .privacyAcknowledgementRequired:
                    return alertWithTitle(title: "Purchase Failed", message: "You have not yet acknowledged Apple’s privacy policy for Apple Music")
                case .unauthorizedRequestData:
                    return alertWithTitle(title: "Purchase Failed", message: "Please contact support")
                case .invalidOfferIdentifier:
                    return alertWithTitle(title: "Purchase Failed", message: "Please contact support")
                case .invalidSignature:
                    return alertWithTitle(title: "Purchase Failed", message: "Please contact support")
                case .missingOfferParams:
                    return alertWithTitle(title: "Purchase Failed", message: "Please contact support")
                case .invalidOfferPrice:
                    return alertWithTitle(title: "Purchase Failed", message: "Please contact support")
                case .paymentCancelled: break
            }
        }
        //not in the tutorial - added
        return alertWithTitle(title: "Did not subscribe", message: "Please contact support if you have questions")
    }
    
    func alertForRestorePurchases(result : RestoreResults) -> UIAlertController {
        if result.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(result.restoreFailedPurchases)")
            return alertWithTitle(title: "Restore Failed", message: "Unknown Error. Please contact support")
        }
        else if result.restoredPurchases.count > 0 {
            return alertWithTitle(title: "Purchases Restored", message: "All purchases have been restored. Close the Pro Subscription view to return to the previous screen, and click on Customize Your Photos to continue adding custom images!")
        }
        else {
            
            return alertWithTitle(title: "Nothing to Restore", message: "No previous purchases were made.")
        }
    }
    
    func alertForVerifyReceipt(result : VerifyReceiptResult) -> UIAlertController {
        
        switch result {
        case .success(let receipt):
            return alertWithTitle(title: "Receipt Verified", message: "Receipt Verified Remotely")
        case .error(let error):
            switch error {
            case .noReceiptData:
                return alertWithTitle(title: "Receipt Verification", message: "No receipt data found, application will try to get a new one. Try again.")
            default:
                return alertWithTitle(title: "Receipt Verification", message: "Receipt verification failed")
            }
        }
    }
    
    func alertForVerifySubscription(result: VerifySubscriptionResult) -> UIAlertController {
        
        switch result {
            
        case .purchased(let expiryDate):
            return alertWithTitle(title: "Product is Purchased", message: "Product is valid until \(expiryDate)")
        
        case .notPurchased:
            return alertWithTitle(title: "Not Purchased", message: "This product has never been purchase")
            
        case .expired(let expiryDate):
            return alertWithTitle(title: "Product Expired", message: "Product is expired since \(expiryDate)")
            
        default: break
            
        }
    }
    
    func alertForVerifyPurchase(result : VerifySubscriptionResult) -> UIAlertController {
        switch result {
        case .purchased:
            return alertWithTitle(title: "Product is Purchased", message: "Product will not expire")
            
        case .notPurchased:
            return alertWithTitle(title: "Product not purchased", message: "Product has never been purchased")
            
        default: break
        }
        
        return alertWithTitle(title: "Did not work", message: "Please contact support")
    }
    

}


