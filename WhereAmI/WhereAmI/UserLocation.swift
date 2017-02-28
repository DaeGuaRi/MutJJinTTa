//
//  UserLocation.swift
//  WhereAmI
//
//  Created by 임성훈 on 2017. 2. 28..
//  Copyright © 2017년 swiftBook. All rights reserved.
//

import Foundation
import CoreLocation
import Realm

class UserLocation {
    var coordinate: CLLocationCoordinate2D
    var locationName: String
    
    init(coordinate: CLLocationCoordinate2D, locationName: String) {
        self.coordinate = coordinate
        self.locationName = locationName
    }
}
