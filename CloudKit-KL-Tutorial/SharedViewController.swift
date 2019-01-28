//
//  SharedViewController.swift
//  CloudKit-KL-Tutorial
//
//  Created by Lucas Tavares on 28/01/19.
//  Copyright © 2019 Lucas Tavares. All rights reserved.
//

import UIKit
import CloudKit

class SharedViewController: UIViewController {
    
    var sharedNotes = [CKRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension SharedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedNotes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let sharedNote = sharedNotes[indexPath.row].value(forKey: "content") as! String
        cell.textLabel?.text = sharedNote
        return cell
    }
}
