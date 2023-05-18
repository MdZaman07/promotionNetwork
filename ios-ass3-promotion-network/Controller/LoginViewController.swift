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
        Task {
            do {
                try? await realmManager.initalize()
            }
        }
        
        // Check if device is already logged in, push to home screen if so
        var deviceId = UIDevice.current.identifierForVendor!.uuidString
        if let loginSession = queryLoginSession(deviceId: deviceId) {
            pushToHomeViewController()
        }
    }
    
    // Query Realm LoginSessions for device ID
    func queryLoginSession(deviceId: String) -> LoginSession? {
        do {
            let realm = try Realm()
            let loginSession = realm.objects(LoginSession.self).filter("deviceId == %@", deviceId).first
            return loginSession
        } catch {
            return nil
        }
    }

    @IBAction func login(_ sender: Any) {
        // Unwrap optionals
        guard let username = usernameField.text else {return}
        guard let password = passwordField.text else {return}

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
            print("User '\(username)' doesn't exist")
            return nil
        }
        
        // Check if passwords match otherwise return nil
        if user.password != password {
            print("Incorrect password")
            return nil
        }
        
        return user
    }
    
    // Query Realm db for an AppUser that matches the username
    func getUserByUsername(username: String) -> AppUser? {
        do {
            let realm = try Realm()
            if let user = realm.objects(AppUser.self).filter("userName == %@", username).first {
                return user
            }
        } catch {
            print("Get user failed, reason: \(error)")
        }
        return nil
    }
}

