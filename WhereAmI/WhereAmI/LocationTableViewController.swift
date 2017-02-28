//
//  ViewController.swift
//  T_boundingCoord
//
//  Created by 송종훈 on 2017. 2. 10..
//  Copyright © 2017년 swiftBook. All rights reserved.
//

import UIKit
import CoreLocation

class LocationTableViewController: UIViewController {
    var cells: Array<String>?
    @IBOutlet var tableView: UITableView!
    let ad = UIApplication.shared.delegate as? AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshViewFor(notification:)),name:NSNotification.Name(rawValue: "refresh"), object: nil)
        ad?.supplier.reverseGeocodeCoordinate()
    }
    @IBAction func refreshBtnClicked(_ sender: UIBarButtonItem) {
        ad?.supplier.reverseGeocodeCoordinate()
    }

    func refreshViewFor(notification: Notification) {
        guard let values = ad?.supplier.locationValue.values else {
            return
        }
        self.cells = Array(values)
        self.tableView.reloadData()
    }
}

//MARK: 테이블에서 발생하는 액션/이벤트와 관련된 메소드 정의
extension LocationTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("\(indexPath.row)번째 데이터가 클릭됨")
    }
}

//MARK: 테이블을 구성하기 위해 필요한 메소드 정의
extension LocationTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cells = self.cells else {
            return 0
        }
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = cells?[indexPath.row]
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font?.fontName)!, size:9)
        return cell
    }
}
