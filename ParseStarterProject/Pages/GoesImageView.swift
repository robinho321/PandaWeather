//
//  GoesImageView.swift
//  PandaWeather
//
//  Created by Robin Allemand on 1/11/20.
//  Copyright © 2020 Parse. All rights reserved.
//

import Foundation
import UIKit
import WebKit

protocol GoesImageViewControllerDelegate {
    func didCloseOnceMoreAgain(controller: GoesImageViewController)
}

class GoesImageViewController: UIViewController, StormListTableViewControllerDelegate, UITextFieldDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var urlTextField: UITextField!
    
    //this is where I need to auto-parse HTML storm data
    func getStormData(controller: StormListTableViewController) {
        
        self.dismiss(animated: true, completion: nil)
        print("\("Got the selected storm data")")
    }
    
    var delegate: GoesImageViewControllerDelegate? = nil
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "openStormListTVC" {
            let navigationController: UINavigationController = segue.destination as! UINavigationController
            let stormListTVC: StormListTableViewController = navigationController.viewControllers[0] as! StormListTableViewController
            stormListTVC.delegate = self
        }
    }
    
    
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        self.delegate?.didCloseOnceMoreAgain(controller: self)
    }
    
    @IBAction func searchHurricanesButton(_ sender: UIBarButtonItem) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlTextField.delegate = self
        webView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
        let urlString:String = "https://www.star.nesdis.noaa.gov/GOES/index.php"
        let url:URL = URL(string: urlString)!
        let urlRequest: URLRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        urlTextField.text = urlString
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let urlString:String = urlTextField.text!
        let url:URL = URL(string: urlString)!
        let urlRequest: URLRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    @IBAction func forwardButton(_ sender: UIButton) {
    if webView.canGoForward {
            webView.goForward()
        }
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
    if webView.canGoBack {
            webView.goBack()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        
        urlTextField.text = webView.url?.absoluteString
    }
    
    /**
     * Handles all HTTP responses, from WKNavigationDelegate
     */
    //    func webView(_ webView: WKWebView,
    //                 decidePolicyFor navigationResponse: WKNavigationResponse,
    //                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    //
    //        guard let statusCode
    //            = (navigationResponse.response as? HTTPURLResponse)?.statusCode else {
    //                // if there's no http status code to act on, exit and allow navigation
    //                decisionHandler(.allow)
    //                return
    //        }
    //
    //        if statusCode >= 400 {
    //            // error has occurred
    //        }
    //
    //        decisionHandler(.allow)
    //    }
    //
    
}
