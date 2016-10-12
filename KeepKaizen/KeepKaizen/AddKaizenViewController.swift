//
//  AddKaizenViewController.swift
//  KeepKaizen
//
//  Created by James Stern on 9/28/16.
//  Copyright © 2016 James Stern. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddKaizenViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var deltaSign: ADVSegmentedControl!
    @IBOutlet weak var deltaLabel: UITextField!
    @IBOutlet weak var goalText: UITextField!
    @IBOutlet weak var frequencyButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var frequencyPicker: UIPickerView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var addButton: UIButton!
    
    var categories = ["Career", "Dining", "Education", "Finance", "Fitness",  "Health", "Personal", "Recreation", "Time" ]
    var freqs = ["Daily", "Weekly", "Monthly"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deltaSign.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)

        frequencyPicker.dataSource = self
        frequencyPicker.delegate = self
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
    }
    
    @IBAction func frequencyButtonPressed(_ sender: AnyObject) {
        frequencyPicker.isHidden = false
        categoryPicker.isHidden = true
        
        addButton.isHidden = true
        
    }

    @IBAction func categoryButtonPressed(_ sender: AnyObject) {
        categoryPicker.isHidden = false
        frequencyPicker.isHidden = true
        
        addButton.isHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1){
            return freqs.count
        } else {
            return categories.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1){
            return freqs[row]
        } else {
            return categories[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1){
            frequencyButton.setTitle(freqs[row], for: UIControlState.normal)
            frequencyPicker.isHidden = true
            
            addButton.isHidden = false
            
        } else {
            categoryButton.setTitle(categories[row], for: UIControlState.normal)
            categoryPicker.isHidden = true
            
            addButton.isHidden = false
            
        }
    }
    func segmentValueChanged(_ sender: AnyObject?){
        
        if deltaSign.selectedIndex == 0 {
            
            deltaLabel.textColor = UIColor(red: 69/255, green: 202/255, blue: 230/255, alpha: 1)
            deltaSign.thumbColor = UIColor(red: 69/255, green: 202/255, blue: 230/255, alpha: 1)
            deltaSign.selectedLabelColor = UIColor.white
            deltaSign.unselectedLabelColor = UIColor(red: 241/255, green: 23/255, blue: 63/255, alpha: 1)
            
        } else {

            deltaLabel.textColor = UIColor(red: 241/255, green: 23/255, blue: 63/255, alpha: 1)
            deltaSign.thumbColor = UIColor(red: 241/255, green: 23/255, blue: 63/255, alpha: 1)
            deltaSign.selectedLabelColor = UIColor(red: 69/255, green: 202/255, blue: 230/255, alpha: 1)
            deltaSign.unselectedLabelColor = UIColor.white
        }
    
    }
    
    
    @IBAction func addGoalButton(_ sender: AnyObject) {
        
        if (goalText.text?.isEmpty)! {
            print("Must enter info")
        } else {
            
            if let user = FIRAuth.auth()?.currentUser {
                
                if let goalContent = goalText.text {
                    
                    let delta = Int(deltaLabel.text!)!
                    
                    let goal: Dictionary<String, AnyObject> = [
                        "content": goalContent as AnyObject,
                        "addedByUser": user.uid as AnyObject,
                        "freq": (frequencyButton.titleLabel?.text)! as AnyObject,
                        "category": (categoryButton.titleLabel?.text)! as AnyObject,
                        "delta": (delta as AnyObject),
                        "deltaSign": (Int(deltaSign.selectedIndex) as AnyObject)
                        
                    ]
                    
                    let goalRef = DataService.ds.REF_GOALS.childByAutoId()
                    goalRef.setValue(goal)
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
