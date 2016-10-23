//
//  Goal.swift
//  KeepKaizen
//
//  Created by James Stern on 9/30/16.
//  Copyright © 2016 James Stern. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Goal {
    
    private var _content:String!
    private var _addedByUser:String!
    private var _freq:String!
    private var _category:String!
    private var _delta:Int!
    private var _deltaSign:Int!
    private var _completions:Int!
    private var _baseline:Int!
    private var _goalKey:String!
    private var _goalRef:FIRDatabaseReference!
    
    var content: String {
        return _content
    }
    
    var addedByUser: String {
        return _addedByUser
    }
    
    var freq:String {
        return _freq
    }
    
    var category: String {
        return _category
    }
    
    var delta: Int {
        return _delta
    }
    
    var deltaSign: Int {
        return _deltaSign
    }
    
    var completions: Int {
        return _completions
    }
    
    var baseline: Int {
        return _baseline
    }
    
    var goalKey: String {
        return _goalKey
    }
    
    init(content:String, addedByUser:String, freq:String, category:String, delta:Int, deltaSign:Int, completions:Int, baseline:Int) {

        self._content = content
        self._addedByUser = addedByUser
        self._freq = freq
        self._category = category
        self._delta = delta
        self._deltaSign = deltaSign
        self._completions = completions
        self._baseline = baseline
        
    }
    
    init(goalKey: String, goalData: Dictionary<String, AnyObject>) {
        
        self._goalKey = goalKey
        
        if let content = goalData["content"] as? String {

            self._content = content
            } else {
                self._content = ""
        }
        if let addedByUser = goalData["addedByUser"] as? String {

            self._addedByUser = addedByUser
        } else {
            self._addedByUser = ""
        }
        if let freq = goalData["freq"] as? String {

            self._freq = freq
        } else {
            self._freq = ""
        }
        if let category = goalData["category"] as? String {

            self._category = category
        } else {
            self._category = ""
        }
        if let delta = goalData["delta"] as? Int {

            self._delta = delta
        } else {
            self._delta = 0
        }
        if let deltaSign = goalData["deltaSign"] as? Int {
            
            self._deltaSign = deltaSign
        } else {
            self._deltaSign = 0
        }
        if let completions = goalData["completions"] as? Int {
            
            self._completions = completions
        } else {
            self._completions = 0
        }
        if let baseline = goalData["baseline"] as? Int {
            
            self._baseline = baseline
        } else {
            self._baseline = 0
        }
        
        _goalRef = DataService.ds.REF_GOALS.child(_goalKey)

        
        
    }
    
}
