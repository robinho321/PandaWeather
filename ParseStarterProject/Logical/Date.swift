//
//  Date.swift
//  PandaWeather
//
//  Created by Robin Allemand on 1/21/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Foundation
import CoreData

func Date() -> [NSManagedObject]? {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext!
    let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    privateMOC.parent = managedContext
    
    let fetchRequest = NSFetchRequest<SyncDate>(entityName:"SyncDate")
    let fetchedResults:NSArray = try! managedContext.fetch(fetchRequest) as NSArray
    let results:NSArray = fetchedResults
    if results.count > 0 {
        //let dates = results[0]
    } else {
        let entity =  NSEntityDescription.entity(forEntityName: "SyncDate", in: managedContext)
        let date = NSManagedObject(entity: entity!, insertInto:managedContext)
        var error: NSError?
        date.setValue("", forKey: "pandaImageDate")
        do {
            try privateMOC.save()
        } catch let error2 as NSError {
            error = error2
            print("Could not save \(String(describing: error)), \(String(describing: error?.userInfo))")
        }
    }
    return results as? [NSManagedObject]
}
