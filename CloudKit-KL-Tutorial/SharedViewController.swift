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
    
    @IBOutlet weak var tableView: UITableView!
    var sharedNotes = [CKRecord]()
    var CKHelper = CloudKitHelper()
    let note = CKRecord(recordType: "Note")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSharedNotes()
        let refreshControl = createRefreshControl(title: "Pull to refresh 🔄", action: #selector(getSharedNotes))
        self.tableView.refreshControl = refreshControl
    }
    
    @IBAction func onPlusTapped(_ sender: Any) {
        alertToAddNotes(database: iCloudDatabaseType.sharedDB.database) { (record,error) in
            print(record)
            print(error)
        }
    }
    
    @objc func getSharedNotes () {
        CKHelper.queryDatabase(database: iCloudDatabaseType.sharedDB.database, note: "Note") { (records) in
            self.sharedNotes = records
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
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
