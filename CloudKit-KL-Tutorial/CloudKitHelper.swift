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
    case sharedDB
    
    var database: CKDatabase {
        switch self {
        case .publicDB:
            return CKContainer.default().publicCloudDatabase
        case .privateDB:
            return CKContainer.default().privateCloudDatabase
        case .sharedDB:
            return CKContainer.default().sharedCloudDatabase
        }
    }
}

class CloudKitHelper  {
    func queryDatabase (database: CKDatabase,note: String ,completion: @escaping ([CKRecord]) -> ()) {
        
        let query = CKQuery(recordType: note, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        database.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records else { return }
            completion(records)
        }
    }
    
    func saveToCloud (note: String, record: CKRecord, database: CKDatabase, completion: @escaping(CKRecord?) -> ()) {
        let newNote = CKRecord(recordType: record.recordType )
        newNote.setValue(note, forKey: "content")
        database.save(newNote) { (record, error) in
            guard record != nil else { return }
            completion(record)
        }
    }
}
