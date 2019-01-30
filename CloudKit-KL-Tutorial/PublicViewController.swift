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
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var color: CKRecord?
    var notes = [CKRecord]()
    var CKHelper = CloudKitHelper()
    let colorRecord = CKRecord(recordType: "Change")
    let note = CKRecord(recordType: "Note")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPublicNotes()
        let refreshControl = createRefreshControl(title: "🔃 Pull to refresh! 🔃", action: #selector(getPublicNotes))
        self.tableView.refreshControl = refreshControl
        // Do any additional setup after loading the view, typically from a nib.
        
        let subscription = CKQuerySubscription(recordType: "Note", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil), options: [.firesOnRecordCreation, .firesOnRecordDeletion, .firesOnRecordUpdate])
        
        let info = CKSubscription.NotificationInfo()
        info.alertLocalizationKey = "change_database_registered_alert"
        info.alertBody = "Banco de dados foi modificado"
        
        subscription.notificationInfo = info
        
        let subscriptionColor = CKQuerySubscription(recordType: "Change", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil), options: [.firesOnRecordUpdate])
        
        let infoColor = CKSubscription.NotificationInfo()
        infoColor.alertLocalizationKey = "change_color_registered_alert"
        infoColor.alertBody = "Atualizacao do app"
        
        subscriptionColor.notificationInfo = infoColor
        
        CKContainer.default().publicCloudDatabase.save(subscription) { [weak self] savedSubscription, error in
            
            print(savedSubscription as Any)
            
            guard let _ = savedSubscription, error == nil else {
                
                print(error?.localizedDescription as Any)
                
                return
            }
        }
        
        CKContainer.default().publicCloudDatabase.save(subscriptionColor) { [weak self] savedSubscription, error in
            
            print(savedSubscription as Any)
            
            guard let _ = savedSubscription, error == nil else {
                
                print(error?.localizedDescription as Any)
                
                return
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(getPublicNotes), name: .shouldReload, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeColor), name: .changeAppColor, object: nil)
    }

    @IBAction func onPlusTapped () {
        alertToAddNotes(database: iCloudDatabaseType.publicDB.database) { (record,error) in
            print(record)
            print(error)
            if let record = record{
                DispatchQueue.main.async {
                    self.notes.insert(record, at: 0)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func getPublicNotes() {
        CKHelper.queryDatabase(database: iCloudDatabaseType.publicDB.database, note: "Note") { (records) in
            self.notes = records
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    @objc func changeColor() {
        CKHelper.queryDatabase(database: iCloudDatabaseType.publicDB.database, note: "Change") { (records) in
            let color = records.first?.value(forKey: "color")
            if color != nil {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.navigationBar.backgroundColor = UIColor.init(named: color as! String)
                    })
                }
            } else {
                print ("didnt found color")
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


