//
//  CloudKitHelper.swift
//  CloudKit-KL-Tutorial
//
//  Created by Lucas Tavares on 28/01/19.
//  Copyright © 2019 Lucas Tavares. All rights reserved.
//

import Foundation
import CloudKit

enum iCloudDatabaseType {
    case publicDB
    case privateDB
    
    var database: CKDatabase {
        switch self {
        case .publicDB:
            return CKContainer.default().publicCloudDatabase
        case .privateDB:
            return CKContainer.default().privateCloudDatabase
        }
    }
}

class CloudKitHelper  {
    func queryDatabase (database: CKDatabase,note: String ,completion: @escaping ([CKRecord]) -> ()) {
        let query = CKQuery(recordType: note, predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records else { return }
            completion(records)
        }
    }
    
    func saveToCloud (note: String, record: CKRecord, database: CKDatabase, completion: @escaping(Bool) -> ()) {
        let newNote = CKRecord(recordType: record.recordType )
        newNote.setValue(note, forKey: "content")
        database.save(newNote) { (record, error) in
            guard record != nil else { return }
            completion(true)
        }
    }
    
    func saveSubscription(subscription: CKQuerySubscription, database: CKDatabase) {
        
        database.save(subscription) { [weak self] savedSubscription, error in
            
            print(savedSubscription as Any)
            
            guard let _ = savedSubscription, error == nil else {
                
                print(error?.localizedDescription)
                
                return
            }
        }
    }
}
