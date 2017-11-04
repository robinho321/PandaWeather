//
//  PandaImage.swift
//  PandaWeather
//
//  Created by Robin Allemand on 10/15/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PandaImage : NSManagedObject
{
    @NSManaged var id: NSNumber?
    @NSManaged var type: NSString!
    @NSManaged var active: Bool
    @NSManaged var image: NSData
    
    override func awakeFromInsert()
    {
        super.awakeFromInsert()
        //dateCreated = NSDate()
    }
}
