//
//  ViewController.swift
//  321
//
//  Created by Student on 3/30/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseDatabase
class ViewController: UIViewController {
    @IBOutlet weak var AccountTextField: UITextField!
    @IBOutlet weak var PasswordTextField:
    UITextField!
    @IBAction func LoginButtonDidTapped(_ sender: UIButton) {
        let email = AccountTextField.text!
        let password = PasswordTextField.text!
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
        // User's account data is in the authResult object that's passed to the callback method.
            if error == nil{
                self.performSegue(withIdentifier: "map", sender: self)
            }
        }
    }
    @IBAction func RegisterButtonDidTapper(_ sender: UIButton) {
        let email = AccountTextField.text!
        let password = PasswordTextField.text!
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil{
                self.performSegue(withIdentifier: "map", sender: self)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
   
    
    func viewWillAppear() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
        //print(user)
            
        }
    }
    func viewWillDisappear() {
        //Auth.auth().removeStateDidChangeListener(handle!)
    }
    
}

