//
//  User.swift
//  KeepKaizen
//
//  Created by James Stern on 9/30/16.
//  Copyright © 2016 James Stern. All rights reserved.
//

import Foundation
import FirebaseAuth

struct User {
    let uid:String
    let email:String
    
    init(userData:FIRUser) {
        
        uid = userData.uid
        
        if let mail = userData.providerData.first?.email {
            
            email = mail
            
        } else {
            email = ""
        }
        
    }
    
    init (uid:String, email:String) {
        
        self.uid = uid
        self.email = email
        
    }
}
