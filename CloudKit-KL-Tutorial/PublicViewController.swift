//
//  ViewController.swift
//  CloudKit-KL-Tutorial
//
//  Created by Lucas Tavares on 25/01/19.
//  Copyright © 2019 Lucas Tavares. All rights reserved.
//

import UIKit
import CloudKit

class PublicViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    
    var notes = [CKRecord]()
    var CKHelper = CloudKitHelper()
    let note = CKRecord(recordType: "Note")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPublicNotes()
        let refreshControl = createRefreshControl(title: "Pull to refresh! 🔃", action: #selector(getPublicNotes))
        self.tableView.refreshControl = refreshControl
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onPlusTapped () {
        alertToAddNotes(database: iCloudDatabaseType.publicDB.database) { (record,error) in
            print(record)
            print(error)
        }
    }
    
    @objc func getPublicNotes () {
        CKHelper.queryDatabase(database: iCloudDatabaseType.publicDB.database, note: "Note") { (records) in
            self.notes = records
            DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}

extension PublicViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let note = notes[indexPath.row].value(forKey: "content") as! String
        cell.textLabel?.text = note
        return cell
    }
}


