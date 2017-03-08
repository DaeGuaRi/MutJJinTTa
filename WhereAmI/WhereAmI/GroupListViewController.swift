//
//  GroupListViewController.swift
//  WhereAmI
//
//  Created by 임성훈 on 2017. 3. 6..
//  Copyright © 2017년 swiftBook. All rights reserved.
//

import Foundation
import UIKit


class GroupListViewController: UIViewController {
    let ad = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
    }
    
    @IBAction func unwindToGL(_ segue: UIStoryboardSegue){}
}

extension GroupListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ListSegue", sender: self)
    }
}


extension GroupListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell")!
        return cell
    }
}
