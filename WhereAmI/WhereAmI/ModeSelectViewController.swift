//
//  GroupListViewController.swift
//  WhereAmI
//
//  Created by 임성훈 on 2017. 3. 6..
//  Copyright © 2017년 swiftBook. All rights reserved.
//

import Foundation
import UIKit


class ModeSelectViewController: UIViewController {
    
    @IBOutlet weak var runningMode: UIButton!
    @IBOutlet weak var studyMode: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runningMode.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        runningMode.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        runningMode.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        
        
        studyMode.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        studyMode.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        studyMode.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
    }

    @IBAction func unwindToMSV(_ segue: UIStoryboardSegue){}
}
