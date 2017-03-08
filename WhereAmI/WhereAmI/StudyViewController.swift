//
//  StudyViewController.swift
//  learningDummy
//
//  Created by 송종훈 on 2017. 2. 28..
//  Copyright © 2017년 swiftBook. All rights reserved.
//

import Foundation
import UIKit

class StudyViewController: UIViewController {
    let ad = UIApplication.shared.delegate as! AppDelegate
    var cells: [String] = [String]()
    
    override func viewDidLoad() {
    }
}

extension StudyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension StudyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudyCell")!
        cell.textLabel?.text = cells[indexPath.row]
        //cell.textLabel?.font = UIFont(name: (cell.textLabel?.font?.fontName)!, size:9)
        return cell
    }
}
