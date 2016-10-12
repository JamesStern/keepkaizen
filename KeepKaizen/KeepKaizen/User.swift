//
//  User.swift
//  KeepKaizen
//
//  Created by James Stern on 9/30/16.
//  Copyright © 2016 James Stern. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    private var _kaizenPoints:Int!
    private var _activity:Dictionary<String, Bool>!
    private var _userKey:String!
    private var _userRef:FIRDatabaseReference!
    
    var kaizenPoints:Int {
        return _kaizenPoints
    }
    var activity:Dictionary<String, Bool> {
        return _activity
    }
    var userKey:String {
        return _userKey
    }
    
    init(kaizenPoints:Int, activity:Dictionary<String, Bool>) {
        self._kaizenPoints = kaizenPoints
        self._activity = activity
    }
    
    init(userKey:String, userData:Dictionary<String, AnyObject>) {
        self._userKey = userKey
        
        if let kaizenPoints = userData["kaizen-points"] as? Int {
            self._kaizenPoints = kaizenPoints
        } else {
            self._kaizenPoints = 110
        }
        if let activity = userData["activity"] as? Dictionary<String, Bool> {
            self._activity = activity
        } else {
            self._activity = ["":false]
        }
        
        _userRef = DataService.ds.REF_USERS.child(_userKey)
        
    }
    
    
    
}
