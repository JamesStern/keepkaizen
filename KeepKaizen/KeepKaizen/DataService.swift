//
//  DataService.swift
//  KeepKaizen
//
//  Created by James Stern on 10/9/16.
//  Copyright © 2016 James Stern. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_GOALS = DB_BASE.child("goal-items")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_GOALS: FIRDatabaseReference {
        return _REF_GOALS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_CURRENT_USER: FIRDatabaseReference {
        let uid = KeychainWrapper.defaultKeychainWrapper().stringForKey(KEY_UID)
        let user = REF_USERS.child(uid!)
        
        return user
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
}
