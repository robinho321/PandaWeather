//
//  WeatherBrowserViewController.swift
//  PandaWeather
//
//  Created by Robin Allemand on 1/18/20.
//  Copyright © 2020 Parse. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import RealmSwift

protocol WeatherBrowserViewControllerDelegate {
    func didCloseOnceMoreAgainAgain(controller: WeatherBrowserViewController)
}

class WeatherBrowserViewController: UIViewController, WKNavigationDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var browserView: WKWebView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    
    var currentWebView: WKWebView!
    var errorView: UIView = UIView()
    var errorLabel: UILabel = UILabel()
    var bookmarks = [Bookmark]()
    var webViews = [WKWebView]()
    
    var delegate: WeatherBrowserViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
        configureSearchBar()
        configureWebViewError()
        loadBookmarks()
        loadWebSite("https://www.star.nesdis.noaa.gov/GOES/index.php", true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
        self.currentWebView.frame = CGRect(x: 0, y: 0, width: self.browserView.frame.width, height: self.browserView.frame.height)
        
    }
    
    //Configuration functions
    func configureSearchBar() {
        searchBar.delegate = self
    }
    
    func configureWebView() {
        let webConfig = WKWebViewConfiguration()
        let frame = CGRect(x: 0.0, y: 0.0, width: browserView.frame.width, height: browserView.frame.height)
        currentWebView = WKWebView(frame: frame, configuration: webConfig)
        currentWebView.navigationDelegate = self
        browserView.addSubview(currentWebView)
    }
    
    func configureWebViewError() {
        var frame = CGRect(x: 0.0, y: 0.0, width: browserView.frame.width, height: browserView.frame.height)
        errorView = UIView(frame: frame)
        errorView.backgroundColor = UIColor.white
        
        frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
        errorLabel = UILabel(frame: frame)
        errorLabel.backgroundColor = UIColor.white
        errorLabel.textColor = UIColor.pastelGrayColor()
        errorLabel.text = ""
        errorLabel.textAlignment = .center
//        errorLabel.font = UIFont(name: "System", size: 25)
        errorLabel.numberOfLines = 0
    }
    
    func loadBookmarks() {
        let realm = try! Realm()
        let results = realm.objects(Bookmark.self)
        bookmarks.removeAll()
        for result in results {
            bookmarks.append(result)
        }
    }
    
    func countBookmarks() -> Int {
        let realm = try! Realm()
        let results = realm.objects(Bookmark.self)
        return results.count
    }
    
    // WKWebview functions
    func loadWebSite(_ input: String, _ isURLDomain: Bool) {
        var encodedURL: String = input
        if (isURLDomain) {
//            encodedURL = input
            if (encodedURL.starts(with: "http://")) {
                encodedURL = String(encodedURL.dropFirst(7))
            } else if (encodedURL.starts(with: "https://")) {
                encodedURL = String(encodedURL.dropFirst(8))
            }

            encodedURL = "https://" + encodedURL
            
        } else {
            encodedURL = "https://www.google.com/search?dcr=0&q=" + encodedURL.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        }
        
        let url: URL = URL(string: "\(encodedURL)")!
        let myRequest: URLRequest = URLRequest(url: url)
        currentWebView.load(myRequest)
        hideWebViewError()
        searchBar.text = encodedURL.lowercased()
    }
    
    func displayWebViewError(_ info: String) {
        errorLabel.text = info
        browserView.addSubview(errorView)
        browserView.addSubview(errorLabel)
    }
    
    func hideWebViewError() {
        errorView.removeFromSuperview()
        errorLabel.removeFromSuperview()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        searchBar.text = currentWebView.url?.absoluteString
    }
    
    //WKNavigationDelegate functions
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Committed")
        updateNavigationToolBarButtons()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished")
        updateNavigationToolBarButtons()
        searchBar.text = currentWebView.url?.absoluteString
    }

//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if let urlStr = navigationAction.request.url?.absoluteString {
//            searchBar.text = urlStr
//        }
//
//        decisionHandler(.allow)
//    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        displayWebViewError(error.localizedDescription)
        updateNavigationToolBarButtons()
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    
    //UISearchBarDelegate functions
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if let url = currentWebView.url?.absoluteString {
            let numberOfBookmarks = countBookmarks()
            let realm = try! Realm()
            let newBookmark: Bookmark = Bookmark(value: ["url": url, "title": currentWebView.title])
            try! realm.write {
                realm.add(newBookmark, update: .all)
            }
            loadBookmarks()
            let numberOfBookmarksAfterClicked = countBookmarks()
            if numberOfBookmarksAfterClicked > numberOfBookmarks {
                self.showToast(message: "Bookmark added")
            } else {
                self.showToast(message: "Bookmark exists")
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let input: String = (searchBar.text?.trimmingCharacters(in: .whitespaces))!
//        if (!input.isEmpty) {
//            //can add a progress bar here - find tutorial
//            if (input.hasSuffix(".com") || input.hasSuffix(".com/") || input.hasSuffix(".tv") || input.hasSuffix(".tv/") || input.hasSuffix(".php") || input.hasSuffix(".php/") || input.hasSuffix(".gov") || input.hasSuffix(".gov/")) {
                loadWebSite(input, true)
//            } else {
//                loadWebSite(input, false)
//            }
//        }
    }
    
    // Toolbar functions
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        self.delegate?.didCloseOnceMoreAgainAgain(controller: self)
    }
    
    @IBAction func infoButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "How to Add Bookmarks", message: "Navigate to a weather site by using the search bar and entering the url. \n \n To bookmark the site, tap the book icon on the right of the search bar. If successful, you will see a message confirming the bookmark was added. \n \n To view your bookmarks, tap on the 'Bookmarks' button on the top right of the view. You can delete bookmarks by swiping right.", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func reloadButton(_ sender: UIBarButtonItem) {
        currentWebView.reload()
    }
    
    @IBAction func forwardButton(_ sender: UIBarButtonItem) {
        currentWebView.goForward()
        hideWebViewError()
        searchBar.text = currentWebView.url?.absoluteString
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        if (errorView.isDescendant(of: browserView)) {
            hideWebViewError()
        } else {
            currentWebView.goBack()
        }
        searchBar.text = currentWebView.url?.absoluteString
    }
    
    func updateNavigationToolBarButtons() {
        if (currentWebView.canGoForward) {
            forwardButton.isEnabled = true
        } else {
            forwardButton.isEnabled = false
        }
        if (currentWebView.canGoBack) {
            backButton.isEnabled = true
        } else {
            backButton.isEnabled = false
        }
    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: -35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 1.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Bookmarks") {
            let bookmarkTVC = segue.destination as! BookmarkTableViewController
            bookmarkTVC.bookmarks = self.bookmarks
            bookmarkTVC.delegate = self
        }
    }
    
    
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        let urlString:String = urlTextField.text!
//        let url:URL = URL(string: urlString)!
//        let urlRequest: URLRequest = URLRequest(url: url)
//        webView.load(urlRequest)
//
//        textField.resignFirstResponder()
//
//        return true
//    }
//
//
//    @IBAction func forwardButton(_ sender: UIButton) {
//        if webView.canGoForward {
//            webView.goForward()
//        }
//    }
//
//
//    @IBAction func backButton(_ sender: UIButton) {
//        if webView.canGoBack {
//            webView.goBack()
//        }
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        backButton.isEnabled = webView.canGoBack
//        forwardButton.isEnabled = webView.canGoForward
//
//        urlTextField.text = webView.url?.absoluteString
//    }
    
}
