//
//  AddNoteError.swift
//  CloudKit-KL-Tutorial
//
//  Created by Lucas Tavares on 29/01/19.
//  Copyright © 2019 Lucas Tavares. All rights reserved.
//

import Foundation

struct AddNoteError:Error {
    let message: String
    
    init() {
        self.message = "Error adding note"
    }
    
    public var localizedDescription: String {
        return message
    }
    
}
