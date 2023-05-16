//
//  ViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 2/5/23.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func login(_ sender: Any) {
        // Unwrap optionals
        guard let username = usernameField.text else {return}
        guard let password = passwordField.text else {return}

        //Validate login
        if (validateLogin(username: username, password: password)) {
            var _ = LoginSession(userId: username)
            
            // Push To Tab Bar Which Pushes to Home Screen
            let vc = storyboard?.instantiateViewController(identifier: "UITabBarController") as! UITabBarController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            print("Invalid login")
        }
    }
    
    func validateLogin(username: String, password: String) -> Bool {
        // (using dummy data for now) get the users from db, validate the user
        let dummyDataReader = JSONDummyDataReader()
        let users = dummyDataReader.users
        
        if (!(users.contains { $0.id == username })) {
            return false
        }
        
        // Get the user and check the password
        let userIndex = users.firstIndex{$0.id == username}
        if(users[userIndex!].password == password) {
            return false
        }
        
        return true
        
    }
    
    
    
}

