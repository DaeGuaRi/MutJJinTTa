//
//  Calcurlator.swift
//  T_boundingCoord
//
//  Created by 송종훈 on 2017. 2. 10..
//  Copyright © 2017년 swiftBook. All rights reserved.
//

import Foundation
import CoreLocation

extension Int {
    var degreesToRadians: Double { return Double(self) * M_PI / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / M_PI }
}

extension Double {
    var degreesToRadians: Double { return self * M_PI / 180 }
    var radiansToDegrees: Double { return self * 180 / M_PI }
}

struct Calculator {
    enum GeoLocationError: Error {
        case InvalidBound
        case InvalidArgument
        case NilValue
    }
    
    func boundingCoordinate(current: CLLocationCoordinate2D, compass: Double, distance: Double) -> CLLocationCoordinate2D {
        let brng = compass.degreesToRadians //Bearing is 305 degrees converted to radians.
        let d = distance / 1000 //Distance in km
        let lat = current.latitude.degreesToRadians
        let lon = current.longitude.degreesToRadians
        
        var boundaryLatitude = asin(sin(lat)*cos(d/ConstValues.earthRadius) + cos(lat)*sin(d/ConstValues.earthRadius)*cos(brng))
        var boundaryLongitude = lon + atan2(sin(brng)*sin(d/ConstValues.earthRadius)*cos(lat), cos(d/ConstValues.earthRadius)-sin(lat)*sin(lat))
        
        boundaryLatitude = boundaryLatitude.radiansToDegrees
        boundaryLongitude = boundaryLongitude.radiansToDegrees
        return CLLocationCoordinate2D(latitude: boundaryLatitude, longitude: boundaryLongitude)
    }
    
    func getDirectionfrom(compass: Double, current: CLLocationCoordinate2D, dest: CLLocationCoordinate2D) -> String {
        let bearing = getBearingfrom(current: current, dest: dest)
        if(bearing == compass) {
            return getDirectionNamefrom(directionValue: bearing)
        } else {
            let value = bearing < compass ? bearing - compass + 360 : bearing - compass
            return getDirectionNamefrom(directionValue: value)
        }
    }
    
    private func getDirectionNamefrom(directionValue: Double) -> String {
        var result: String = "열두시";
        
        if(345 < directionValue || directionValue <= 15){
            result = "열두시";
        }else if(15 < directionValue && directionValue <= 45){
            result = "한시";
        }else if(45 < directionValue && directionValue <= 75){
            result = "두시";
        }else if(75 < directionValue && directionValue <= 105){
            result = "세시";
        }else if(105 < directionValue && directionValue <= 135){
            result = "네시";
        }else if(135 < directionValue && directionValue <= 165){
            result = "다섯시";
        }else if(165 < directionValue && directionValue <= 195){
            result = "여섯시";
        }else if(195 < directionValue && directionValue <= 225){
            result = "일곱시";
        }else if(225 < directionValue && directionValue <= 255){
            result = "여덟시";
        }else if(255 < directionValue && directionValue <= 285){
            result = "아홉시";
        }else if(285 < directionValue && directionValue <= 315){
            result = "열시";
        }else if(315 < directionValue && directionValue <= 345){
            result = "열한시";
        }
        return result;
    }
    
    private func getBearingfrom(current: CLLocationCoordinate2D, dest: CLLocationCoordinate2D) -> Double {
        var y: Double,x: Double;
        var ret: Double;
        
        let P1_lat = current.latitude.degreesToRadians
        let P1_lon = current.longitude.degreesToRadians
      
        let P2_lat = dest.latitude.degreesToRadians
        let P2_lon = dest.longitude.degreesToRadians
        
        y = sin(P2_lon - P1_lon) * cos(P2_lat)
        x = cos(P1_lat) * sin(P2_lat) - sin(P1_lat) * cos(P2_lat) * cos(P2_lon - P1_lon)
        
        ret = atan2(y,x);
        return ret.radiansToDegrees
    }
    
    func getDistancefrom(current: CLLocationCoordinate2D, dest: CLLocationCoordinate2D) -> Int {
        let currentCoordinate = CLLocation(latitude: current.latitude, longitude: current.longitude)
        let destCoordinate = CLLocation(latitude: dest.latitude, longitude: dest.longitude)
        let distance = currentCoordinate.distance(from: destCoordinate)
        return Int(distance)
    }
}
