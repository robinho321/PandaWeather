//
//  Bookmark.swift
//  PandaWeather
//
//  Created by Robin Allemand on 1/19/20.
//  Copyright © 2020 Parse. All rights reserved.
//

import Foundation
import RealmSwift

class Bookmark: Object {
    //attributes
    @objc dynamic var url: String = ""
    @objc dynamic var title: String = ""
    
    //debugging key
    override static func primaryKey() -> String {
        return "url"
    }
    
    //check what's stored in database
    var bookmarkDescription: String {
        let urlDescription = "URL: \(url)\n"
        let titleDescription = "Title: \(title)\n"
        return "Bookmark information:\n\(urlDescription)\(titleDescription)\n"
    }
    
}
