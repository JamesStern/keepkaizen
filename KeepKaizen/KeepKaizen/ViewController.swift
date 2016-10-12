//
//  ViewController.swift
//  KeepKaizen
//
//  Created by James Stern on 9/28/16.
//  Copyright © 2016 James Stern. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var kaizenPts: UILabel!
    @IBOutlet weak var completions: UILabel!
    @IBOutlet weak var streak: UILabel!
    @IBOutlet weak var goalsCount: UILabel!
    
    @IBOutlet weak var goalsTable: UITableView!
    
    var goal:Goal!
    var goals = [Goal]()
    var points = Int()
    var pointChange = Int()
    var completionsArr = [Int]()
    var completionRef:FIRDatabaseReference!
    var streakArr:[String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.ds.REF_CURRENT_USER.observe(.value, with: { (snapshot:FIRDataSnapshot) in
            self.points = (snapshot.value as? NSDictionary)?["kaizen-points"] as! Int
            
            self.kaizenPts.text = String(self.points)
        
        })
        
        DataService.ds.REF_CURRENT_USER.child("activity").observe(.childAdded, with: { (snapshot) in
            
            
            print("JAMES: \(snapshot.key)")
            
            
            })
        
        startObservingDB()
        
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateString = dateFormatter.string(from: date as Date)
        
        let date1_str = "20161001"
        let date2_str = "20160901"
        
        let secondDate = dateFormatter.date(from: date1_str)
        let firstDate = dateFormatter.date(from: date2_str)
        
        print("JAMES: \(daysBetweenDates(startDate: firstDate!, endDate: secondDate!))")

        
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int
    {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day!
    }
    
    func startObservingDB() {
        
        DataService.ds.REF_GOALS.observe(.value, with: { (snapshot) in
            
            self.goals = []
            
            self.completionsArr = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                print("JAMES goals \(snapshot)")
                for snap in snapshot {
                    if let goalDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let goal = Goal(goalKey: key, goalData: goalDict)
                        
                        if goal.addedByUser == FIRAuth.auth()?.currentUser?.uid {
                        self.goals.append(goal)
                        self.completionsArr.append(goal.completions)
                        }
                    }
                }
            }

            self.goalsTable.reloadData()
            self.goalsCount.text = String(self.goals.count)
            self.completions.text = String(self.completionsArr.reduce(0, +))
            
        }) { (error:Error) in
                
                print(error)
                
        }
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func addBtn(_ sender: AnyObject) {
        performSegue(withIdentifier: "addNew", sender:  sender)
    }
    
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let goal = goals[indexPath.row]
        
        let cell:GoalsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as! GoalsTableViewCell
        
        cell.delagate = self
        
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.white
        }else {
            cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        }
        
        cell.configureCell(goal: goal)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = indexPath.row
        
        let delta = goals[cell].delta
        
        let newPoints:Int = self.points + delta
        
        DataService.ds.REF_CURRENT_USER.setValue(["kaizen-points": newPoints])

        
        
   }
    

}

