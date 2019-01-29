//
//  UIViewController+AddNoteAlert.swift
//  CloudKit-KL-Tutorial
//
//  Created by Lucas Tavares on 29/01/19.
//  Copyright © 2019 Lucas Tavares. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

extension UIViewController {
    func alertToAddNotes(database: CKDatabase,completion: @escaping(CKRecord?,AddNoteError?) -> ()) {
        let alert = UIAlertController(title: "Type Something", message: "What would you like to in save?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Type note here."
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let text = alert.textFields?.first?.text else { return }
            CloudKitHelper().saveToCloud(note: text, record: CKRecord(recordType: "Note") , database: database, completion: { (record) in
                if let record = record {
                    completion(record, nil)
                } else {
                    completion(nil,AddNoteError())
                }
            })
        }
        
        alert.addAction(cancel)
        alert.addAction(post)
        present(alert, animated: true, completion: nil)
    }
}
