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
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var teams = [NSManagedObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
                as! ImageCell
            let team = fetchedResultsController.object(at: indexPath)
            cell.WeatherTypeLabel.text = team.value(forKey: "type") as? String
            if (team.value(forKey: "image") != nil)
            {
                cell.PandaImage.image = UIImage(data: (team.value(forKey: "image") as? Data)!)
            }
            return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let team = fetchedResultsController.object(at: indexPath)
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
        
        DispatchQueue.main.async(execute: {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "passwordUpdated"), object: nil, userInfo: nil)
        });
        
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
            sectionNameKeyPath: "active",
            cacheName: nil)
        return frc
    }()
    
}
