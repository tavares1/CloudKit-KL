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
    
    let publicDatabase = CKContainer.default().publicCloudDatabase
    var notes = [CKRecord]()
    var CKHelper = CloudKitHelper()
    let note = CKRecord(recordType: "Note")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryDatabase()
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(queryDatabase), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        // Do any additional setup after loading the view, typically from a nib.
        
        let subscription = CKQuerySubscription(recordType: "Note", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil), options: [.firesOnRecordCreation, .firesOnRecordDeletion, .firesOnRecordUpdate])
        
        let info = CKSubscription.NotificationInfo()
        info.alertLocalizationKey = "note_registered_alert"
        info.alertBody = "Nova nota publica adicionada"
        
        subscription.notificationInfo = info
        
        CKHelper.saveSubscription(subscription: subscription, database: publicDatabase)
    }

    @IBAction func onPlusTapped () {
        let alert = UIAlertController(title: "Type Something", message: "What would you like to in save?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Type note here."
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let text = alert.textFields?.first?.text else { return }
            self.CKHelper.saveToCloud(note: text, record: self.note , database: iCloudDatabaseType.publicDB.database , completion: { (sucess) in
                if(sucess) {
                    print("Record add with sucess!")
                } else {
                    print("error while trying add record in iClod")
                }
                self.queryDatabase()
            })
        }
        
        alert.addAction(cancel)
        alert.addAction(post)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func queryDatabase() {
        CKHelper.queryDatabase(database: publicDatabase, note: "Note") { (records) in
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
