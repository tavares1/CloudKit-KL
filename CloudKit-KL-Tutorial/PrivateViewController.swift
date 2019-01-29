//
//  PrivateViewController.swift
//  CloudKit-KL-Tutorial
//
//  Created by Lucas Tavares on 28/01/19.
//  Copyright © 2019 Lucas Tavares. All rights reserved.
//

import UIKit
import CloudKit

class PrivateViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var privateNotes = [CKRecord]()
    let CKHelper = CloudKitHelper()
    let note = CKRecord(recordType: "Note")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPrivateNotes()
        let refreshControl = createRefreshControl(title: "Pull to refresh 🔄", action: #selector(getPrivateNotes))
        self.tableView.refreshControl = refreshControl
    }

    @IBAction func onPlusTapped(_ sender: Any) {
        alertToAddNotes(database: iCloudDatabaseType.privateDB.database) { (record,error) in
            print(record)
            print(error)
        }
    }
    
    @objc func getPrivateNotes () {
        CKHelper.queryDatabase(database: iCloudDatabaseType.privateDB.database, note: "Note") { (records) in
            self.privateNotes = records
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}

extension PrivateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return privateNotes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let note = privateNotes[indexPath.row].value(forKey: "content") as! String
        cell.textLabel?.text = note
        return cell
    }
}
