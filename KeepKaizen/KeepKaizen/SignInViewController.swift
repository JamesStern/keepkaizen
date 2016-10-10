//
//  SignInViewController.swift
//  KeepKaizen
//
//  Created by James Stern on 10/9/16.
//  Copyright © 2016 James Stern. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase
import SwiftKeychainWrapper

class SignInViewController: UIViewController {

    @IBOutlet weak var email: HoshiTextField!
    @IBOutlet weak var password: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.defaultKeychainWrapper().stringForKey(KEY_UID) {
            performSegue(withIdentifier: "goToHome", sender: nil)
        }
    }
    
    @IBAction func signInPressed(_ sender: AnyObject) {
        if let email = email.text, let pwd = password.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("User logged in with email")
                    if let user = user {
                        let userData = ["email": email] as [String : Any]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                    
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Unable to create user")
                            let alertController = UIAlertController(title: "Error", message: "You must enter an email and password.", preferredStyle: .alert)
                            
                            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                                print("Alert dismissed");
                            }
                            
                            alertController.addAction(OKAction)
                            self.present(alertController, animated: true, completion:nil)
                            
                        } else {
                            print("User created with email")
                            if let user = user {
                                let userData = ["email": email, "kaizen-points": 0] as [String : Any]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
        
        
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, Any>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.defaultKeychainWrapper().setString(id, forKey: KEY_UID)
        print("Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToHome", sender: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }


}
