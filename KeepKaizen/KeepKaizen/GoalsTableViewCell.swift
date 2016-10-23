//
//  GoalsTableViewCell.swift
//  KeepKaizen
//
//  Created by James Stern on 9/30/16.
//  Copyright © 2016 James Stern. All rights reserved.
//

import UIKit
import Firebase

class GoalsTableViewCell: UITableViewCell {

    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var freqLabel: UILabel!
    @IBOutlet weak var deltaLabel: UILabel!
    @IBOutlet weak var compLabel: UILabel!
    @IBOutlet weak var goalIcon: UIImageView!
    @IBOutlet weak var goalView: UIView!
    
    var goal:Goal!
    var dateString:String!
    var goalRef:FIRDatabaseReference!
    var completionRef:FIRDatabaseReference!
    
    var delagate: UIViewController?
    
    override func awakeFromNib() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(goalTapped))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
        dateFormatter.dateFormat = "yyyyMMdd"
        dateString = dateFormatter.string(from: date as Date)

    }
    
    func configureCell(goal: Goal) {
        self.goal = goal
        completionRef = DataService.ds.REF_CURRENT_USER.child("activity").child(dateString).child(goal.goalKey)
        
        self.goalsLabel.text = goal.content
        self.freqLabel.text = goal.freq
        self.deltaLabel.text = String(goal.baseline)
        self.compLabel.text = "\(String(goal.completions)) completions"
        
        let catImage = goal.category.uppercased()
        self.goalIcon.image = UIImage(named: "\(catImage).png")
        
        if goal.deltaSign == 0 {
            
            self.deltaLabel.textColor = UIColor(red: 69/255, green: 202/255, blue: 230/255, alpha: 1)
        } else {
            
            self.deltaLabel.textColor = UIColor(red: 241/255, green: 23/255, blue: 63/255, alpha: 1)
        }
    }
    
    func goalTapped(sender: UITapGestureRecognizer) {
        
        let currentCompletions = goal.completions
        
        completionRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.completionRef.setValue(true)
                DataService.ds.REF_GOALS.child(self.goal.goalKey).child("completions").setValue(currentCompletions + 1)
                
                if self.goal.deltaSign == 0 {
                    DataService.ds.REF_GOALS.child(self.goal.goalKey).child("baseline").setValue(self.goal.baseline + self.goal.delta)
                } else {
                    
                    if self.goal.baseline == 0 {
                        
                    } else {
                        DataService.ds.REF_GOALS.child(self.goal.goalKey).child("baseline").setValue(self.goal.baseline - self.goal.delta)
                    }
                    
                    
                }
                
                let newPoints = points + self.goal.baseline
                DataService.ds.REF_CURRENT_USER.child("kaizen-points").setValue(newPoints)
            } else {
                let alertController = UIAlertController(title: "Oops!", message: "You've already completed this goal today.", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                    print("Alert dismissed");
                }
                
                alertController.addAction(OKAction)
                self.delagate?.present(alertController, animated: true, completion:nil)
            }
            
        })
        
    }

}
