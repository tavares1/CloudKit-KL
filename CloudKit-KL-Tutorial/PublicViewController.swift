//
//  ViewController.swift
//  CloudKit-KL-Tutorial
//
//  Created by Lucas Tavares on 25/01/19.
//  Copyright © 2019 Lucas Tavares. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    
    let database = CKContainer.default().publicCloudDatabase
    var notes = [CKRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryDatabase()
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(queryDatabase), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onPlusTapped () {
        let alert = UIAlertController(title: "Type Something", message: "What would you like to in save?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Type note here."
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let text = alert.textFields?.first?.text else { return }
            self.saveToCloud(note: text)
        }
        
        alert.addAction(cancel)
        alert.addAction(post)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveToCloud (note: String) {
        let newNote = CKRecord(recordType: "Note")
        newNote.setValue(note, forKey: "content")
        
        database.save(newNote) { (record, error) in
            guard record != nil else { return }
            let recordSaved = record?.object(forKey: "content")
            self.queryDatabase()
        }
    }
    
    @objc func queryDatabase () {
        let query = CKQuery(recordType: "Note", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records else { return }
            self.notes = records
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
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
