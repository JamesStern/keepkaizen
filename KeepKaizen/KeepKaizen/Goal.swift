//
//  Goal.swift
//  KeepKaizen
//
//  Created by James Stern on 9/30/16.
//  Copyright © 2016 James Stern. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Goal {
    
    let key:String!
    let content:String!
    let addedByUser:String!
    let freq:String!
    let category:String!
    let delta:Int!
    let deltaSign:Int!
    var completions:Int!
    let date1:String!
    let date2:String!
    let itemRef:FIRDatabaseReference?
    
    init (content:String, addedByUser:String, freq:String, category:String, delta:Int, deltaSign:Int, completions:Int, date1:String, date2:String, key:String = "") {
        
        self.key = key
        self.content = content
        self.addedByUser = addedByUser
        self.freq = freq
        self.category = category
        self.delta = delta
        self.deltaSign = deltaSign
        self.completions = completions
        self.date1 = date1
        self.date2 = date2
        self.itemRef = nil
        
    }
    
    init (snapshot:FIRDataSnapshot) {
        
        key = snapshot.key
        itemRef = snapshot.ref
        
        if let goalContent = (snapshot.value as? NSDictionary)?["content"] as? String {
            
            content = goalContent
            } else {
                content = ""
        }
        if let goalUser = (snapshot.value as? NSDictionary)?["addedByUser"] as? String {
            
            addedByUser = goalUser
        } else {
            addedByUser = ""
        }
        if let goalFreq = (snapshot.value as? NSDictionary)?["freq"] as? String {
            
            freq = goalFreq
        } else {
            freq = ""
        }
        if let goalCategory = (snapshot.value as? NSDictionary)?["category"] as? String {
            
            category = goalCategory
        } else {
            category = ""
        }
        if let goalDelta = (snapshot.value as? NSDictionary)?["delta"] as? Int {
            
            delta = goalDelta
        } else {
            delta = 0
        }
        if let goalDeltaSign = (snapshot.value as? NSDictionary)?["deltaSign"] as? Int {
            
            deltaSign = goalDeltaSign
        } else {
            deltaSign = 0
        }
        if let goalCompletions = (snapshot.value as? NSDictionary)?["completions"] as? Int {
            
            completions = goalCompletions
        } else {
            completions = 0
        }
        if let goalDate1 = (snapshot.value as? NSDictionary)?["date1"] as? String {
            
            date1 = goalDate1
        } else {
            date1 = nil
        }
        if let goalDate2 = (snapshot.value as? NSDictionary)?["date2"] as? String {
            
            date2 = goalDate2
        } else {
            date2 = nil
        }

    }
    
    func toAnyObject() -> AnyObject {
        
        let output:Dictionary<String, Any> = ["content":content!, "addedByUser":addedByUser!, "freq":freq!, "category":category!, "delta":delta!, "deltaSign":deltaSign!, "completions":completions!, "date1":date1!, "date2":date2! ]
        
        return output as AnyObject
    }

}
