//
//  LocationServer.swift
//  T_boundingCoord
//
//  Created by 송종훈 on 2017. 2. 10..
//  Copyright © 2017년 swiftBook. All rights reserved.
//

import Foundation
import CoreLocation

class LocationSupplier {
    var portioner: Portioner? = nil
    var compass: CLLocationDirection = CLLocationDirection()
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var radius: CLLocationDistance = 50
    let calculator: Calculator = Calculator()
    var locationValue: Dictionary<String,String> = Dictionary<String,String>()

    init() {
        portioner = Portioner(outer: self)
    }
    
    func reverseGeocodeCoordinate() {
        locationValue.removeAll()
        self.portioner?.executeWorks()
    }
    private func getVicinityCompanyNamefrom(current: CLLocationCoordinate2D, compass: CLLocationDirection) -> Void {
        let uri: URL! = URL(string: "\(ConstValues.GMSGeoUrl)\(current.latitude),\(current.longitude)&radius=\(self.radius)&language=ko&key=\(ConstValues.GMSGeoKey)")
        let apiData = try! Data(contentsOf: uri)
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apiData, options: []) as! NSDictionary
            let results = apiDictionary["results"] as! NSArray
            if results.count > 0 {
                for result in results {
                    var ret: Bool = Bool(true)
                    let row = result as! NSDictionary
                    let types = row["types"] as! [String]
                    /* Exception Check */
                    for type in types {
                        if (type == "political") {
                            ret = false
                            break;
                        }
                    }
                    if (ret == false) {
                        continue
                    }
                    /* parsing */
                    let vicinity = row["vicinity"] as! String
                    let name = row["name"] as! String
                    let key = row["place_id"] as! String
                    let geometry = row["geometry"] as! NSDictionary
                    let location = geometry["location"] as! NSDictionary
                    let lat = location.value(forKey: "lat") as! Double
                    let lng = location.value(forKey: "lng") as! Double
                    let dest = CLLocationCoordinate2D(latitude: lat,longitude: lng)
                    /* compute */
                    let distance = calculator.getDistancefrom(current: self.coordinate, dest: dest)
                    let bearing = calculator.getDirectionfrom(compass: self.compass, current: self.coordinate, dest: dest)
                    let value = vicinity + " " + name + " " + bearing + "방향" + " " + String(distance) + "m"
                    locationValue[key] = value
                }
            }
        } catch {
            NSLog("JSONSerialization Error!")
        }
    }
    
    private func getVicinityAddrfrom(current: CLLocationCoordinate2D, compass: CLLocationDirection) -> Void {
        let apiURI : URL! = URL(string: "\(ConstValues.GMSPlaceUrl)\(current.latitude),\(current.longitude)&key=\(ConstValues.GMSPlaceKey)")
        let apidata = try! Data(contentsOf: apiURI)
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            let results = apiDictionary["results"] as! NSArray
            if results.count > 0 {
                for result in results {
                    let row = result as! NSDictionary
                    let geometry = row["geometry"] as! NSDictionary
                    let location_type = geometry.value(forKey: "location_type") as! String
                    if location_type == "ROOFTOP" {
                        let formatted_address = row["formatted_address"] as! String
                        let key = row["place_id"] as! String
                        let location = geometry["location"] as! NSDictionary
                        let lat = location.value(forKey: "lat") as! Double
                        let lng = location.value(forKey: "lng") as! Double
                        let dest = CLLocationCoordinate2D(latitude: lat,longitude: lng)
                        /* compute */
                        let distance = calculator.getDistancefrom(current: self.coordinate, dest: dest)
                        let bearing = calculator.getDirectionfrom(compass: self.compass, current: self.coordinate, dest: dest)
                        let value = formatted_address + " " + bearing + "방향" + " " + String(distance) + "m"
                        locationValue[key] = value
                    }
                }
            }
        } catch {
            NSLog("JSONSerialization Error!")
        }
    }
    
    //MARK: Network WorkItem distribute
    class Portioner {
        let outer: LocationSupplier
        //DispatchGroup
        let group = DispatchGroup()
        //Concurrent Queue
        let center = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        let north = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        let east = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        let south = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        let west = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        let northWest = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        let southEast = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        let northEast = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        let southWest = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        //Task
        var centerWorkItem: DispatchWorkItem? = nil
        var northWorkItem: DispatchWorkItem? = nil
        var eastWorkItem: DispatchWorkItem? = nil
        var southWorkItem: DispatchWorkItem? = nil
        var westWorkItem: DispatchWorkItem? = nil
        var northWestWorkItem: DispatchWorkItem? = nil
        var southEastWorkItem: DispatchWorkItem? = nil
        var northEastWorkItem: DispatchWorkItem? = nil
        var southWestWorkItem: DispatchWorkItem? = nil
        
        init(outer: LocationSupplier) {
            self.outer = outer
        }
        
        func getWorkItemsBy(radius: CLLocationDistance) {
            switch radius {
            case 100:
                getWorkItemsOfQuatrePoints()
            case 200:
                getWorkItemsOfOmnidirectionalPoints()
            default:
                getWorkItemsOfCenterPoint()
            }
        }
        
        func getWorkItemsOfCenterPoint() {
            self.centerWorkItem = DispatchWorkItem {
                self.outer.getVicinityAddrfrom(current: self.outer.coordinate, compass: self.outer.compass)
                //self.outer.getVicinityCompanyNamefrom(current: self.outer.coordinate, compass: self.outer.compass)
            }
        }
        
        func getWorkItemsOfQuatrePoints() {
            getWorkItemsOfCenterPoint()
            self.northWorkItem = DispatchWorkItem {
                let northPoint = self.outer.calculator.boundingCoordinate(current: self.outer.coordinate, compass: ConstValues.North, distance: 85)
                self.outer.getVicinityAddrfrom(current: northPoint, compass: self.outer.compass)
            }
            self.eastWorkItem = DispatchWorkItem {
                let eastPoint = self.outer.calculator.boundingCoordinate(current: self.outer.coordinate, compass: ConstValues.East, distance: 85)
                self.outer.getVicinityAddrfrom(current: eastPoint, compass: self.outer.compass)
            }
            self.southWorkItem = DispatchWorkItem {
                let southPoint = self.outer.calculator.boundingCoordinate(current: self.outer.coordinate, compass: ConstValues.South, distance: 85)
                self.outer.getVicinityAddrfrom(current: southPoint, compass: self.outer.compass)
            }
            self.westWorkItem = DispatchWorkItem {
                let westPoint = self.outer.calculator.boundingCoordinate(current: self.outer.coordinate, compass: ConstValues.West, distance: 85)
                self.outer.getVicinityAddrfrom(current: westPoint, compass: self.outer.compass)
            }
        }
        
        func getWorkItemsOfOmnidirectionalPoints() {
            getWorkItemsOfCenterPoint()
            getWorkItemsOfQuatrePoints()
            self.northWestWorkItem = DispatchWorkItem {
                let northWestPoint = self.outer.calculator.boundingCoordinate(current: self.outer.coordinate, compass: ConstValues.NorthWest, distance: 120)
                self.outer.getVicinityAddrfrom(current: northWestPoint, compass: self.outer.compass)
            }
            self.southEastWorkItem = DispatchWorkItem {
                let southEastPoint = self.outer.calculator.boundingCoordinate(current: self.outer.coordinate, compass: ConstValues.SouthEast, distance: 120)
                self.outer.getVicinityAddrfrom(current: southEastPoint, compass: self.outer.compass)
            }
            self.northEastWorkItem = DispatchWorkItem {
                let northEastPoint = self.outer.calculator.boundingCoordinate(current: self.outer.coordinate, compass: ConstValues.NorthEast, distance: 120)
                self.outer.getVicinityAddrfrom(current: northEastPoint, compass: self.outer.compass)
            }
            self.southWestWorkItem = DispatchWorkItem {
                let southWestPoint = self.outer.calculator.boundingCoordinate(current: self.outer.coordinate, compass: ConstValues.SouthWest, distance: 120)
                self.outer.getVicinityAddrfrom(current: southWestPoint, compass: self.outer.compass)
            }
        }
        
        func execWorkItemsCenterPoint() {
            self.center.async(group: group, execute: centerWorkItem!)
        }
        
        func execWorkItemsOfQuatrePoints() {
            execWorkItemsCenterPoint()
            self.north.async(group: group, execute: northWorkItem!)
            self.east.async(group: group, execute: eastWorkItem!)
            self.south.async(group: group, execute: southWorkItem!)
            self.west.async(group: group, execute: westWorkItem!)
        }
        
        func execWorkItemsOfOmnidirectionalPoints() {
            execWorkItemsOfQuatrePoints()
            self.northWest.async(group: group, execute: northWestWorkItem!)
            self.southEast.async(group: group, execute: southEastWorkItem!)
            self.northEast.async(group: group, execute: northEastWorkItem!)
            self.southWest.async(group: group, execute: southWestWorkItem!)
        }
        
        func execWorkItemsBy(radius: CLLocationDistance) {
            switch radius {
            case 100:
                execWorkItemsOfQuatrePoints()
            case 200:
                execWorkItemsOfOmnidirectionalPoints()
            default:
                execWorkItemsCenterPoint()
            }
        }
        
        func executeWorks() {
            let rad = outer.radius
            getWorkItemsBy(radius: rad)
            execWorkItemsBy(radius: rad)
            group.notify(queue: DispatchQueue.main) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
            }
        }
    }
}
