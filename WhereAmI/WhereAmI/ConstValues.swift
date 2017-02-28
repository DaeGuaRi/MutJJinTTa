//
//  ConstValues.swift
//  T_boundingCoord
//
//  Created by 송종훈 on 2017. 2. 12..
//  Copyright © 2017년 swiftBook. All rights reserved.
//

import Foundation


struct ConstValues {
    static let GMSKey: String = "AIzaSyAO1jyDKitml4KYAdaqmUDqKgd9VYyQCs4" // Google Maps Key
    static let GMSGeoKey: String = "AIzaSyA3xrklvEZRmS6gLC2eVT-kyk5csorlNto" // Google Maps Geocoding API Key
    static let GMSPlaceKey: String = "AIzaSyAFA2O_c6D5dtprgTgI6fyBFIwIK5UVWMU" // Google Maps Place API Key
    static let GMSGeoUrl: String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
    static let GMSPlaceUrl: String = "https://maps.googleapis.com/maps/api/geocode/json?&latlng="
    static let earthRadius: Double = 6371.01 //Radius of the Earth
    static let North: Double = 360
    static let East: Double = 90
    static let South: Double = 180
    static let West: Double = 270
    static let NorthWest: Double = 315
    static let SouthEast: Double = 135
    static let NorthEast: Double = 45
    static let SouthWest: Double = 225
    static let boundary: [String] = ["Choose a Meter", "50", "100", "200"]
}
