//
//  MapViewController.swift
//  T_boundingCoord
//
//  Created by 송종훈 on 2017. 2. 12..
//  Copyright © 2017년 swiftBook. All rights reserved.
//
import GoogleMaps
import CoreLocation
import Foundation
import UIKit

import Realm
import RealmSwift

class MapViewController: UIViewController {
    var mapView: GMSMapView = GMSMapView()
    var circle: GMSCircle = GMSCircle()
    var myLocationMark: GMSMarker = GMSMarker()
    let locationManager: CLLocationManager = CLLocationManager()
    let ad = UIApplication.shared.delegate as? AppDelegate
    var realm: Realm!
    var userLocation: UserLocation = UserLocation()
    
    override func viewDidLoad() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        myLocationMark.title = "myLoc"
        myLocationMark.icon = UIImage(named: "MyLocation")
        circle.strokeColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.09)
        circle.fillColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.05)
        mapView.frame = CGRect.zero
        mapView.isMyLocationEnabled = false
        mapView.isUserInteractionEnabled = false
        self.view = mapView
        /* realm test
        userLocation.locationName = "기모찌"
        userLocation.latitude = 2.2
        userLocation.longitude = 2.3
        realm = ad?.realm
        try! realm.write {
            realm.add(userLocation)
        }
        let loadLocation = realm.objects(UserLocation.self).filter("locationName = '기모찌'")
        print(loadLocation.first!.locationName, loadLocation.first!.latitude)
                    */
    }
    @IBAction func setBoundary(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Set a Boundary", message: "\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet);
            //  Create a frame (placeholder/wrapper) for the picker and then create the picker
        let pickerFrame = CGRect(x: 50, y: 30, width: 250, height: 100)
        let picker: UIPickerView = UIPickerView(frame: pickerFrame);
            //  set the pickers datasource and delegate
        picker.delegate = self;
        picker.dataSource = self;
        picker.showsSelectionIndicator = true
            //  Add the picker to the alert controller
        alert.view.addSubview(picker);
            
            //Do stuff and action on appropriate object.
        let actionOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(actionOK)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: 단말기의 위치좌표정보와 방향각을 얻기 위해 필요한 메소드 정의
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { 
            return
        }
        mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: { () -> Float in
            if(ad?.supplier.radius == 200){
                return 16.8
            }
            else{
                return 18.8
            }}(), bearing: (ad?.supplier.compass)!, viewingAngle: 0)
        ad?.supplier.coordinate.latitude = location.coordinate.latitude
        ad?.supplier.coordinate.longitude = location.coordinate.longitude
        circle.position = location.coordinate
        myLocationMark.position = location.coordinate
        circle.radius = (ad?.supplier.radius)!
        circle.map = mapView
        myLocationMark.map = mapView
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let compass = newHeading.trueHeading < 0.0 ? newHeading.magneticHeading : newHeading.trueHeading
        ad?.supplier.compass = compass
        mapView.animate(toBearing: compass)
    }
}

extension MapViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ConstValues.boundary.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ConstValues.boundary[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row > 0 else {
            return
        }
        ad?.supplier.radius = Double(ConstValues.boundary[row])!
        
        switch ad?.supplier.radius {
        case CLLocationDis100:
            mapView.animate(toZoom: 18.8)
        case 200:
            mapView.animate(toZoom: 16.8)
        default:
            <#code#>
        }
        
        
        else {
            
        }
        circle.radius = (ad?.supplier.radius)!
        circle.map = mapView
    }
}

