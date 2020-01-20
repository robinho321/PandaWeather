//
//  populationFunctions.swift
//  PandaWeather
//
//  Created by Robin Allemand on 1/19/20.
//  Copyright © 2020 Parse. All rights reserved.
//

import Foundation
import RealmSwift

//func isRealmPopulatedWithDefaultTab() -> Bool {
//    let realm = try! Realm()
//    if (realm.objects(Tab.self).count > 0) {
//        return true
//    }
//    return false
//}
//
//func populateRealmWithDefaultTab() {
//    let realm = try! Realm()
//    let defaultBookmark: Tab = Tab(value: ["url": "https://www.star.nesdis.noaa.gov/GOES/index.php", "initial url": "https://www.star.nesdis.noaa.gov/GOES/index.php", "title": "GOES Image Viewer"])
//    try! realm.write {
//        realm.add(defaultTab)
//    }
//}
