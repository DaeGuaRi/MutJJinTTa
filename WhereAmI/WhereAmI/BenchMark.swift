//
//  BenchMark.swift
//  WhereAmI
//
//  Created by 임성훈 on 2017. 3. 9..
//  Copyright © 2017년 swiftBook. All rights reserved.
//

import Foundation
import RealmSwift

class BenchMark: Object {
    dynamic var benchMarkName: String = ""
    var nearbyLocations: List<NearbyLocation> = List<NearbyLocation>()
}
