//
//  SyncDate.swift
//  PandaWeather
//
//  Created by Robin Allemand on 12/31/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SyncDate: NSManagedObject
{
    @NSManaged var pandaImageDate: NSString?
    
    override func awakeFromInsert()
    {
        super.awakeFromInsert()
        //dateCreated = NSDate()
    }
}
