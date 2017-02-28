//
//  LoadingViewController.swift
//  test
//
//  Created by EH NGNS on 2017. 2. 11..
//  Copyright © 2017년 EH NGNS. All rights reserved.
//

import UIKit
import CoreLocation
import SystemConfiguration

class LoadingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var loadingView = UILoadingView(frame: self.view.bounds, text: "Loading...")
        self.view.addSubview(loadingView)
        
        //Loading... 화면에서 1초후에 네트워크 설정확인을 시작한다.
        let networkCheckingTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: networkCheckingTime) {

            NSLog("1");
            loadingView = UILoadingView(frame: self.view.bounds, text: "Checking the network...")
            self.view.addSubview(loadingView)

            NSLog("2");
            //네트워크 허용설정 확인
            if(self.connectedToNetwork()){
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, "Conneted Network")
                })
                NSLog("Conneted Network");
                
                loadingView = UILoadingView(frame: self.view.bounds, text: "Checking the GPS...")
                self.view.addSubview(loadingView)
                
                //위치정보 허용설정 확인
                if(CLLocationManager.locationServicesEnabled()) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, "Location services are enabled")
                    })
                    NSLog("Location services are enabled");
                    
                    //네트워크, GPS 설정이 모두 되어있을 경우 메인화면으로 넘어간다.
                    self.performSegue(withIdentifier: "showLoading", sender: self)
                    
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, "Location services are not enabled")
                    })
                    NSLog("Location services are not enabled");
                    exit(0);
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, "Not Conneted Network")
                })
                NSLog("Not Conneted Network");
                exit(0);
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //네트워크 연결상태 체크
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags : SCNetworkReachabilityFlags = []
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}
