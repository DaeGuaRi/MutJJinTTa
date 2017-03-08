//
//  LocationGroup.swift
//  WhereAmI
//
//  Created by 임성훈 on 2017. 2. 28..
//  Copyright © 2017년 swiftBook. All rights reserved.
//

import Foundation
import RealmSwift

class LocationGroup: Object {
    var locations: List<UserLocation> = List<UserLocation>()
    dynamic var groupName: String = ""
    
    override static func primaryKey() -> String? {
        return "groupName"
    }
    
    func insert(location: UserLocation) -> Bool {
        locations.append(location)
        
        for row in locations {
            if row.locationName == location.locationName {
                return true
            }
        }
        return false
    }
    
    func update(oldName: String, newName: String) -> Bool {
        for row in locations {
            if row.locationName == oldName {
                row.locationName = newName
                return true
            }
        }
        return false
    }
    
    func delete(locationName: String) -> Bool {
        for row in 0..<locations.count {
            if locations[row].locationName == locationName {
                locations.remove(at: row)
                return true
            }
        }
        return false
    }
}
