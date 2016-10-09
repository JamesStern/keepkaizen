//
//  SignOutVC.swift
//  KeepKaizen
//
//  Created by James Stern on 10/9/16.
//  Copyright © 2016 James Stern. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SignOutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let keychainResult = KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(KEY_UID)
        print("User logged out \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "signOutSegue", sender: nil)
    }

}
