//
//  UserLocation.swift
//  WhereAmI
//
//  Created by 임성훈 on 2017. 2. 28..
//  Copyright © 2017년 swiftBook. All rights reserved.
//

import Foundation
import RealmSwift

class UserLocation: Object {
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var locationName: String = ""
    
    override static func primaryKey() -> String? {
        return "locationName"
    }
}
