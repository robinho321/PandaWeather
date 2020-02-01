//
//  City.swift
//  PandaWeather
//
//  Created by Robin Allemand on 1/25/20.
//  Copyright © 2020 Parse. All rights reserved.
//

import Foundation
import RealmSwift

class City: Object {
    //attributes
    @objc dynamic var city: String = ""
    @objc dynamic var title: String = ""
    
    //debugging key
    override static func primaryKey() -> String {
        return "city"
    }
    
    //check what's stored in database
    var cityDescription: String {
        let cityDescription = "City: \(city)\n"
        let titleDescription = "Title: \(title)\n"
        return "City information:\n\(cityDescription)\n\(titleDescription)\n"
    }
    
}
