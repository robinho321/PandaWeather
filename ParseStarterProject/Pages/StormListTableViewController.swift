//
//  StormListTableViewController.swift
//  PandaWeather
//
//  Created by Robin Allemand on 9/4/19.
//  Copyright © 2019 Parse. All rights reserved.
//

//import Foundation
//import UIKit
//import QuartzCore
//import Photos
//import SwiftSoup
//
//protocol StormListTableViewControllerDelegate {
//    func getStormData(controller: StormListTableViewController)
//}
//
//class StormListTableViewController: UITableViewController {
//
//    var delegate: StormListTableViewControllerDelegate? = nil
//
//
//
//    let twoDimensionalArray = [
//            ["Anna", "Bob", "Cary", "Dan"],
//            ["John", "Max", "Doug"],
//            ["Adam", "Frank"]
//        ]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let url = URL(string: "https://www.nhc.noaa.gov/cyclones/")
//        guard let myURL = url else {
//            print("Error: \(String(describing: url)) doesn't seem to be a valid URL")
//            return
//        }
//        let htmlContent = try! String(contentsOf: myURL, encoding: .utf8)
//
//        do {
//
//            let doc: Document = try SwiftSoup.parse(htmlContent)
//
//            let a: Element = try doc.select("a").first()!
//            let link: String = try a.attr("href")
////            let text: String = try a.text()
//            print("a link: \(link)")
//
//            let img: Element = try doc.select("img").first()!
//            let mylink: String = try img.attr("src")
//            print("img mylink: \(mylink)")
//
//
//
//        } catch Exception.Error(type: let type, Message: let message) {
//            print("Type: \(type)")
//            print("Message: \(message)")
//        } catch {
//            print("error")
//        }
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//        label.text = "Atlantic" //get the html and assign "\(stormNameFromHTML)"
//        label.backgroundColor = UIColor.lightGray
//        label.font = UIFont(name: label.font.fontName, size: 25)
//        return label
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        //need to create method that to parse storm data array.
//        return twoDimensionalArray.count
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        //need to create method that to parse storm data array.
//        return twoDimensionalArray[section].count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//
//        let stormName = twoDimensionalArray[indexPath.section][indexPath.row]
//        cell.textLabel?.text = stormName
//
//
//        return cell
//    }
//
//    //share - take the user to the URL that is my app
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//
//        if let index = self.tableView.indexPathForSelectedRow{
//            self.tableView.deselectRow(at: index, animated: true)
//        }
//
//        if indexPath.count > 0 {
//            self.delegate?.getStormData(controller: self)
//        }
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        if let index = self.tableView.indexPathForSelectedRow{
//            self.tableView.deselectRow(at: index, animated: true)
//        }
//    }
//}
