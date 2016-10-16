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
import Charts


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChartViewDelegate {
    
    @IBOutlet weak var kaizenPts: UILabel!
    @IBOutlet weak var completions: UILabel!
    @IBOutlet weak var streak: UILabel!
    @IBOutlet weak var goalsCount: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    
    @IBOutlet weak var goalsTable: UITableView!
    
    var goal:Goal!
    var goals = [Goal]()
    var pointChange = Int()
    var completionsArr = [Int]()
    var completionRef:FIRDatabaseReference!
    var streakArr:[String]!
    var currentStreak = 0
    var dailyCompsCount:[Int]!
    var dailyCompsDict:Dictionary<String, Any>!
    
    var months = ["First", "Second", "Third", "Fourth", "Fifth"]
    var sampleData = [1,2,3,1,2]

    override func viewDidLoad() {
        super.viewDidLoad()
        startObservingDB()
        
        chartView.delegate = self
        chartView = LineChartView.fr
        chartView.drawGridBackgroundEnabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(true)
        chartView.setViewPortOffsets(left: 20, top: 0, right: 20, bottom: 0)
        chartView.leftAxis.enabled = false
        chartView.leftAxis.spaceTop = 0.4
        chartView.rightAxis.enabled = false
        chartView.rightAxis.spaceTop = 0.4
        chartView.xAxis.enabled = false
        chartView.pinchZoomEnabled = false
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int
    {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day!
    }
    
    func startObservingDB() {
        
        DataService.ds.REF_CURRENT_USER.observe(.value, with: { (snapshot:FIRDataSnapshot) in
            points = (snapshot.value as? NSDictionary)?["kaizen-points"] as! Int
            self.kaizenPts.text = String(points)
            
            if (snapshot.value as? NSDictionary)?["streak"] as? Int != nil {
            self.currentStreak = (snapshot.value as? NSDictionary)?["streak"] as! Int
            print("JAMES: Streak init \(self.currentStreak)")
            if self.currentStreak == 1 {
                self.streak.text = String(self.currentStreak) + " day"
            } else {
                self.streak.text = String(self.currentStreak) + " days"
            }
            } else {
                print("JAMES: zero")
            }
        })
        
        DataService.ds.REF_CURRENT_USER.child("activity").observe(.value, with: { (snapshot) in
            
            self.streakArr = []
            self.dailyCompsCount = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    self.streakArr.append(snap.key)
                    self.dailyCompsDict = snap.value as! Dictionary<String, Any>!
                    
                    let count = self.dailyCompsDict.count
                    //let countDouble = Double(count)
                    self.dailyCompsCount.append(count)
                }
                
                print("JAMES \(self.streakArr!)")
                print("JAMES \(self.dailyCompsCount!)")
            }
            
            if self.streakArr.count > 1 {
                let totalDays = self.streakArr.count
                let today = totalDays - 1
                let lastDay = totalDays - 2
                
                let diff = Int(self.streakArr[today])! - Int(self.streakArr[lastDay])!
                
                if diff == 1 {
                    let addToStreak = self.currentStreak + 1
                    print(addToStreak)
                    //DataService.ds.REF_CURRENT_USER.child("streak").setValue(self.currentStreak + 1)
                } else {
                    //DataService.ds.REF_CURRENT_USER.child("streak").setValue(0)
                }
            } else {
                
            }
            self.setChartData(months: self.months)
            
        })
        
        DataService.ds.REF_GOALS.observe(.value, with: { (snapshot) in
            
            self.goals = []
            
            self.completionsArr = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
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
    
    func setChartData (months: [String]) {
        
        chartView.noDataText = "Progress will appear as soon as you start completing tasks!"
        chartView.chartDescription?.text = ""
        chartView.chartDescription?.textColor = UIColor.white
        chartView.drawGridBackgroundEnabled = false
        //chartView.drawBordersEnabled = false
        //chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< months.count {
            yVals1.append(ChartDataEntry(x: Double(sampleData[i]), y: Double(i)))
        }
        
            
            let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "")
            set1.axisDependency = .left // Line will correlate with left axis values
            set1.setColor(UIColor(red: 69/255, green: 202/255, blue: 230/255, alpha: 1))
            set1.setCircleColor(UIColor(red: 69/255, green: 202/255, blue: 230/255, alpha: 1)) // our circle will be dark red
            set1.lineWidth = 4.0
            set1.circleRadius = 8.0 // the radius of the node circle
            set1.fillColor = UIColor(red: 69/255, green: 202/255, blue: 230/255, alpha: 1)
            set1.highlightColor = UIColor.white
            set1.drawCircleHoleEnabled = false
            let gradientColors = [UIColor.cyan.cgColor, UIColor.clear.cgColor] // Colors of the gradient
            let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors as CFArray, locations: colorLocations) // Gradient Object
            set1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
            set1.drawFilledEnabled = true // Draw the Gradient
            
            //3 - create an array to store our LineChartDataSets
            var dataSets : [LineChartDataSet] = [LineChartDataSet]()
            dataSets.append(set1)
            
            //4 - pass our months in for our x-axis label value along with our dataSets
            let data:LineChartData = LineChartData(dataSets: dataSets)
            data.setValueTextColor(UIColor.white)
        
            self.chartView.data = data
        
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
        
   }
    

}

