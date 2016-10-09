//
//  SignInViewController.swift
//  KeepKaizen
//
//  Created by James Stern on 10/9/16.
//  Copyright © 2016 James Stern. All rights reserved.
//

import UIKit
import TextFieldEffects

class SignInViewController: UIViewController {

    @IBOutlet weak var email: HoshiTextField!
    @IBOutlet weak var password: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func signInPressed(_ sender: AnyObject) {
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}
