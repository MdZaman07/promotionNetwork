//
//  ViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 2/5/23.
//

import UIKit

class CreateProfileViewController: UIViewController {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createProfile(_ sender: Any) {
        // Unwrap optionals
        guard let username = usernameField.text else {return}
        guard let firstName = firstNameField.text else {return}
        guard let lastName = lastNameField.text else {return}
        guard let password = passwordField.text else {return}
        guard let city = cityField.text else {return}
        guard let description = descriptionField.text else {return}

        // Create new user instance
        let newUser = User(id: username, firstName: firstName, lastName: lastName, password: password, city: city, description: description)
        
        // (Use dummy data for now) add user to database
        let dummydataReader = JSONDummyDataReader()
        dummydataReader.createUser(newUser: newUser)
        
        // Push Login Screen
        let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

