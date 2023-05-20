//
//  ViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 2/5/23.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    private var realmManager = RealmManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        applyBorderStylingToTextFields(fields: [usernameField, passwordField])
        
        // Mask password
        passwordField.isSecureTextEntry = true
        
        // Change corner radius of sign up button later
        
        Task {
            do {
                try! await realmManager.initalize()
                
                if let session = LoginSession.getLoginSession() {
                    session.logout()
                    //pushToHomeViewController()
                }
            }
        }
    }
    
    // When login button is pressed
    @IBAction func login(_ sender: Any) {
        // Validate text fields
        guard let username = usernameField.text, !username.isEmpty else {textFieldErrorAction(field: usernameField, msg: "Username can't empty"); return}
        guard let password = passwordField.text, !password.isEmpty else {textFieldErrorAction(field: passwordField, msg: "Password can't empty"); return}

        //Validate login
        if let user = validateLogin(username: username, password: password) {
            
            // Create new login session and add to Realm db
            _ = LoginSession(appUser: user)
            
            // Push to Home Screen
            pushToHomeViewController()
        } else {
            print("Invalid login")
        }
    }
    
    // Push To Tab Bar Which Pushes to Home Screen
    func pushToHomeViewController() {
        let vc = storyboard?.instantiateViewController(identifier: "UITabBarController") as! UITabBarController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Validate text input fields with database
    func validateLogin(username: String, password: String) -> AppUser? {
        // Check if user exists otherwise return nil
        guard let user = getUserByUsername(username: username) else {
            // Change textfield border color, add error message
            textFieldErrorAction(field: usernameField, msg: "User '\(username)' doesn't exist")
            return nil
        }
        
        // Check if passwords match otherwise return nil
        if user.password != password {
            textFieldErrorAction(field: passwordField, msg: "Incorrect password")
            return nil
        }
        
        return user
    }
    
    // Query Realm db for an AppUser that matches the username
    func getUserByUsername(username: String) -> AppUser? {
        guard let realm = realmManager.realm else {
            print("Failed to establish connection to realm")
            return nil
        }
            if let user = realm.objects(AppUser.self).filter("userName == %@", username).first {
                return user
            }
        return nil
    }
}

