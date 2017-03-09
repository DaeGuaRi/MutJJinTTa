//
//  BenchMarkGroup.swift
//  WhereAmI
//
//  Created by 임성훈 on 2017. 2. 28..
//  Copyright © 2017년 swiftBook. All rights reserved.
//

import Foundation
import RealmSwift

class BenchMarkGroup: Object {
    dynamic var groupName: String = ""
    var benchMarks: List<BenchMark> = List<BenchMark>()
    // Key 값이 기준점
    
    override static func primaryKey() -> String? {
        return "groupName"
    }
    
    func insert(benchMark: String, locations: [String]) -> Bool {
      //  benchMarks[benchMark] = locations
        return false
    }
    
    func delete(benchMark: String) -> Bool {
       // benchMarks[benchMark] = nil
        return false
    }
    
}
