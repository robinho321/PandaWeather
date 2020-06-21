//
//  IAPService.swift
//  PandaWeather
//
//  Created by Robin Allemand on 6/6/20.
//  Copyright © 2020 Parse. All rights reserved.
//

import Foundation
import StoreKit

//public typealias SuccessBlock = () -> Void
//public typealias FailureBlock = (Error?) -> Void
//
//let IAP_PRODUCTS_DID_LOAD_NOTIFICATION = Notification.Name("IAP_PRODUCTS_DID_LOAD_NOTIFICATION")
//
//class IAPService : NSObject{
//
//    private var sharedSecret = "8e13b53a200e4a7cab5f9f7de05ec664"
//    @objc static let shared = IAPService()
//    @objc private(set) var products : Array<SKProduct>?
//
//    private override init(){}
//    private var productIds : Set<String> = []
//
//    private var successBlock : SuccessBlock?
//    private var failureBlock : FailureBlock?
//
//    private var refreshSubscriptionSuccessBlock : SuccessBlock?
//    private var refreshSubscriptionFailureBlock : FailureBlock?
//
//    // MARK:- Main methods
//
//    @objc func startWith(arrayOfIds : Set<String>!, sharedSecret : String){
//        SKPaymentQueue.default().add(self)
//        self.sharedSecret = sharedSecret
//        self.productIds = arrayOfIds
//        loadProducts()
//    }
//
//    func expirationDateFor(_ identifier : String) -> Date?{
//        return UserDefaults.standard.object(forKey: identifier) as? Date
//    }
//
//    func purchaseProduct(product : SKProduct, success: @escaping SuccessBlock, failure: @escaping FailureBlock){
//
//        guard SKPaymentQueue.canMakePayments() else {
//            return
//        }
//        guard SKPaymentQueue.default().transactions.last?.transactionState != .purchasing else {
//            return
//        }
//        self.successBlock = success
//        self.failureBlock = failure
//        let payment = SKPayment(product: product)
//        SKPaymentQueue.default().add(payment)
//    }
//
//    func restorePurchases(success: @escaping SuccessBlock, failure: @escaping FailureBlock){
//        self.successBlock = success
//        self.failureBlock = failure
//        SKPaymentQueue.default().restoreCompletedTransactions()
//    }
//
//    /* It's the most simple way to send verify receipt request. Consider this code as for learning purposes. You shouldn't use current code in production apps.
//     This code doesn't handle errors.
//     */
//    func refreshSubscriptionsStatus(callback : @escaping SuccessBlock, failure : @escaping FailureBlock){
//
//        self.refreshSubscriptionSuccessBlock = callback
//        self.refreshSubscriptionFailureBlock = failure
//
//        guard let receiptUrl = Bundle.main.appStoreReceiptURL else {
//            refreshReceipt()
//            // do not call block in this case. It will be called inside after receipt refreshing finishes.
//            return
//        }
//
//        #if DEBUG
//        let urlString = "https://sandbox.itunes.apple.com/verifyReceipt"
//        #else
//        let urlString = "https://buy.itunes.apple.com/verifyReceipt"
//        #endif
//        let receiptData = try? Data(contentsOf: receiptUrl).base64EncodedString()
//        let requestData = ["receipt-data" : receiptData ?? "", "password" : self.sharedSecret, "exclude-old-transactions" : true] as [String : Any]
//        var request = URLRequest(url: URL(string: urlString)!)
//        request.httpMethod = "POST"
//        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//        let httpBody = try? JSONSerialization.data(withJSONObject: requestData, options: [])
//        request.httpBody = httpBody
//
//        URLSession.shared.dataTask(with: request)  { (data, response, error) in
//            DispatchQueue.main.async {
//                if data != nil {
//                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments){
//                        self.parseReceipt(json as! Dictionary<String, Any>)
//                        return
//                    }
//                } else {
//                    print("error validating receipt: \(error?.localizedDescription ?? "")")
//                }
//                self.refreshSubscriptionFailureBlock?(error)
//                self.cleanUpRefeshReceiptBlocks()
//            }
//            }.resume()
//    }
//
//    /* It's the most simple way to get latest expiration date. Consider this code as for learning purposes. You shouldn't use current code in production apps.
//     This code doesn't handle errors or some situations like cancellation date.
//     */
//    private func parseReceipt(_ json : Dictionary<String, Any>) {
//        guard let receipts_array = json["latest_receipt_info"] as? [Dictionary<String, Any>] else {
//            self.refreshSubscriptionFailureBlock?(nil)
//            self.cleanUpRefeshReceiptBlocks()
//            return
//        }
//        for receipt in receipts_array {
//            let productID = receipt["product_id"] as! String
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
//            if let date = formatter.date(from: receipt["expires_date"] as! String) {
//                if date > Date() {
//                    // do not save expired date to user defaults to avoid overwriting with expired date
//                    UserDefaults.standard.set(date, forKey: productID)
//                }
//            }
//        }
//        self.refreshSubscriptionSuccessBlock?()
//        self.cleanUpRefeshReceiptBlocks()
//    }
//
//    /*
//     Private method. Should not be called directly. Call refreshSubscriptionsStatus instead.
//     */
//    private func refreshReceipt(){
//        let request = SKReceiptRefreshRequest(receiptProperties: nil)
//        request.delegate = self
//        request.start()
//    }
//
//    public func loadProducts(){
//        let products: Set = [IAPProduct.autoRenewingSubscriptionMonth.rawValue, IAPProduct.autoRenewingSubscriptionYear.rawValue]
//        let request = SKProductsRequest.init(productIdentifiers: products)
//        request.delegate = self
//        request.start()
//    }
//
//    private func cleanUpRefeshReceiptBlocks(){
//        self.refreshSubscriptionSuccessBlock = nil
//        self.refreshSubscriptionFailureBlock = nil
//    }
//}
//
//// MARK:- SKReceipt Refresh Request Delegate
//extension IAPService : SKRequestDelegate {
//
//    func requestDidFinish(_ request: SKRequest) {
//        if request is SKReceiptRefreshRequest {
//            refreshSubscriptionsStatus(callback: self.successBlock ?? {}, failure: self.failureBlock ?? {_ in})
//        }
//    }
//
//    func request(_ request: SKRequest, didFailWithError error: Error){
//        if request is SKReceiptRefreshRequest {
//            self.refreshSubscriptionFailureBlock?(error)
//            self.cleanUpRefeshReceiptBlocks()
//        }
//        print("error: \(error.localizedDescription)")
//    }
//}
//
//// MARK:- SKProducts Request Delegate
//extension IAPService: SKProductsRequestDelegate {
//
//    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        products = response.products
//        DispatchQueue.main.async {
//            NotificationCenter.default.post(name: IAP_PRODUCTS_DID_LOAD_NOTIFICATION, object: nil)
//        }
//    }
//}
//
//// MARK:- SKPayment Transaction Observer
//extension IAPService: SKPaymentTransactionObserver {
//
//    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//
//        for transaction in transactions {
//            switch (transaction.transactionState) {
//            case .purchased:
//                SKPaymentQueue.default().finishTransaction(transaction)
//                notifyIsPurchased(transaction: transaction)
//                break
//            case .failed:
//                SKPaymentQueue.default().finishTransaction(transaction)
//                print("purchase error : \(transaction.error?.localizedDescription ?? "")")
//                self.failureBlock?(transaction.error)
//                cleanUp()
//                break
//            case .restored:
//                SKPaymentQueue.default().finishTransaction(transaction)
//                notifyIsPurchased(transaction: transaction)
//                break
//            case .deferred, .purchasing:
//                break
//            default:
//                break
//            }
//        }
//    }
//
//    private func notifyIsPurchased(transaction: SKPaymentTransaction) {
//        refreshSubscriptionsStatus(callback: {
//            self.successBlock?()
//            self.cleanUp()
//        }) { (error) in
//            // couldn't verify receipt
//            self.failureBlock?(error)
//            self.cleanUp()
//        }
//    }
//
//    func cleanUp(){
//        self.successBlock = nil
//        self.failureBlock = nil
//    }
//}

//class IAPService: NSObject {
//
//    private override init() {}
//    static let shared = IAPService()
//
//    var products = [SKProduct]()
//    let paymentQueue = SKPaymentQueue.default()
//
//    func getProducts() {
//        let products: Set = [IAPProduct.autoRenewingSubscriptionMonth.rawValue, IAPProduct.autoRenewingSubscriptionYear.rawValue]
//        let request = SKProductsRequest(productIdentifiers: products)
//        request.delegate = self
//        request.start()
//        paymentQueue.add(self)
//    }
//
//    func purchase(product: IAPProduct) {
//        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first else { return }
//        let payment = SKPayment(product: productToPurchase)
//        paymentQueue.add(payment)
//    }
//
//}
//
//extension IAPService: SKProductsRequestDelegate {
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        print(response.products)
//        self.products = response.products
//        for product in response.products {
//            print(product.localizedTitle)
//        }
//    }
//}
//
//extension IAPService: SKPaymentTransactionObserver {
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction in transactions {
//            print(transaction.transactionState)
//            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
//        }
//    }
//}
//
//extension SKPaymentTransactionState {
//    func status() -> String {
//        switch self  {
//        case .deferred: return "deferred"
//        case .failed: return "failed"
//        case .purchased: return "purchased"
//        case .purchasing: return "purchasing"
//        case .restored: return "restored"
//        }
//    }
//}

//public struct SKError {
//    public enum Code : Int {
//        case unknown
//        case paymentCancelled
//        case clientInvalid
//        case paymentInvalid
//        case paymentNotAllowed
//        case cloudServiceNetworkConnectionFailed
//        case cloudServicePermissionDenied
//        case storeProductNotAvailable
//        case cloudServiceRevoked
//    }
//}
