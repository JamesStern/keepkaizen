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
    @IBOutlet weak var totalDays: UILabel!
    @IBOutlet weak var streak: UILabel!
    @IBOutlet weak var goalsCount: UILabel!
    
    @IBOutlet weak var goalsTable: UITableView!
    
    var goals = [Goal]()
    var points = [Int]()
    var pointChange = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startObservingDB()
                
    }
    
    func startObservingDB() {
        
        DataService.ds.REF_GOALS.observe(.value, with: { (snapshot:FIRDataSnapshot) in
            
            var newItems = [Goal]()
            
            for goal in snapshot.children {
                
                let goalObject = Goal(snapshot: goal as! FIRDataSnapshot)
                    
                    if goalObject.addedByUser == FIRAuth.auth()?.currentUser?.uid {
                        newItems.append(goalObject)
                        self.points.append(goalObject.completions)
                    }
                
                
            
            }
            
            self.goals = newItems
            self.goalsTable.reloadData()
            self.goalsCount.text = String(self.goals.count)
            self.pointChange = self.points.reduce(0,+)
            self.kaizenPts.text = String(self.pointChange)
            
        }) { (error:Error) in
                
                print(error)
                
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell:GoalsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as! GoalsTableViewCell

        let goal = goals[indexPath.row]
        cell.goalsLabel?.text = goal.content
        cell.freqLabel?.text = goal.freq
        cell.deltaLabel.text = String(goal.delta)
        
        if goal.deltaSign == 0 {
            
            cell.deltaLabel.textColor = UIColor(red: 69/255, green: 202/255, blue: 230/255, alpha: 1)
        } else {
        
            cell.deltaLabel.textColor = UIColor(red: 241/255, green: 23/255, blue: 63/255, alpha: 1)
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = indexPath.row
        print(goals[cell].addedByUser)
        
        let delta = goals[cell].delta
        
//        if goals[cell].deltaSign == 0 {
//            self.points.append(goals[cell].delta)
//        } else {
//            self.points.append(goals[cell].delta)
//        }
//        print(self.points)
        //self.kaizenPts.text = String(self.points)
   }

}

