//
//  SideMenuVC.swift
//  KeepKaizen
//
//  Created by James Stern on 10/9/16.
//  Copyright © 2016 James Stern. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SideMenuVC: UITableViewController {

    @IBOutlet weak var userEmail: UILabel!
    
    @IBAction func signOutTapped(_ sender: AnyObject) {
        //performSegue(withIdentifier: "goToSignOut", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.ds.REF_CURRENT_USER.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let email = value?["email"] as! String
            self.userEmail.text = email
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    @IBAction func resetData(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "All Data Will Be Deleted!", message: "Press OK to delete all activity data.", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            DataService.ds.REF_CURRENT_USER.child("activity").removeValue()
            DataService.ds.REF_CURRENT_USER.child("kaizen-points").setValue(0)
            DataService.ds.REF_CURRENT_USER.child("streak").setValue(0)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction) in
            print("Data reset cancelled.")
        }
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)

    }

    @IBAction func clearGoals(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "All Goal data will be deleted!", message: "Press OK to delete all goal data.", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            DataService.ds.REF_GOALS.observe(.value, with: { (snapshot) in

                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshot {
                        if let goalDict = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            let goal = Goal(goalKey: key, goalData: goalDict)

                            if goal.addedByUser == FIRAuth.auth()?.currentUser?.uid {
                                DataService.ds.REF_GOALS.child(key).removeValue()
                            }
                        }
                    }
                }
                
            }) { (error:Error) in
                
                print(error)
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction) in
            print("Data reset cancelled.")
        }
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func deleteUser(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "All User data will be deleted!", message: "Press OK to delete all user data.", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        
            let user = FIRAuth.auth()?.currentUser
            
            user?.delete { error in
                if let error = error {
                    print("Error deleting: \(error)")
                } else {
                    print("User deleted")
                    DataService.ds.REF_CURRENT_USER.removeValue()
                    let keychainResult = KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(KEY_UID)
                    print(keychainResult)

                    self.performSegue(withIdentifier: "goToSignOut", sender: nil)
                    
//                    self.performSegue(withIdentifier: "userDeleted", sender: nil)
                }
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction) in
            print("Data reset cancelled.")
        }
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)
    }


}
