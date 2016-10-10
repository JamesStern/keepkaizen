//
//  DBUser.swift
//  KeepKaizen
//
//  Created by James Stern on 10/9/16.
//  Copyright © 2016 James Stern. All rights reserved.
//

import Foundation
import Firebase

struct DBUser {
    
    let key:String!
    let email:String!
    let kaizenPoints:Int!
    let itemRef:FIRDatabaseReference?
    
    init (email:String, kaizenPoints:Int, key:String = "") {
        
        self.email = email
        self.kaizenPoints = kaizenPoints
        self.key = key
        self.itemRef = nil
        
    }
    
    init (snapshot:FIRDataSnapshot) {
        
        key = snapshot.key
        itemRef = snapshot.ref
        
        if let userEmail = (snapshot.value as? NSDictionary)?["email"] as? String {
            
            email = userEmail
        } else {
            email = ""
        }
        
        if let userPoints = (snapshot.value as? NSDictionary)?["kaizen-points"] as? Int {
            
            kaizenPoints = userPoints
        } else {
            kaizenPoints = 50
        }
        
        
    }
    
    func toAnyObject() -> AnyObject {
        let output:Dictionary<String, Any> = ["email":email!, "kaizen-points":kaizenPoints!]
        
        return output as AnyObject
    }
}


