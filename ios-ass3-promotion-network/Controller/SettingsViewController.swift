//
//  ViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 2/5/23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var profileContainerView: UIView!
    
    @IBOutlet weak var profilePictureField: UIImageView!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var locationField: UILabel!
    @IBOutlet weak var nameField: UILabel!
    var loginSession: LoginSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Check for a log in session, otherwise return to login screen
        guard let loginSession = LoginSession.getLoginSession() else {
            // There is no saved login session or the decoding failed
            print("Login session not found")
            let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        self.loginSession = loginSession
        
        // Get login session and populate the profile container subviews
        let loggedInProfile = getCurrentUser()!
        nameField.text = loggedInProfile.userName
        locationField.text = loggedInProfile.city
        
        // Get image from S3 and populate image field
        if !loggedInProfile.profileImageKey.elementsEqual("") {
            AWSManager.shared.getOneImage(key: loggedInProfile.profileImageKey){ [weak self] result in
                switch result{
                case .success (let image):
                    DispatchQueue.main.async {
                        self?.profilePictureField.contentMode = .scaleAspectFit
                        self?.profilePictureField.image = image
                    }
                case .failure(let error):
                    self?.profilePictureField.image = UIImage(systemName: "person.fill")
                    print(error)
                }
            }
        } else {
            profilePictureField.image = UIImage(systemName: "person.fill")
        }
        
        
        // Add touch gesture to profile container to show profile view
        let uiTapGR = UITapGestureRecognizer(target: self, action: #selector(self.showProfileView))
        profileContainerView.addGestureRecognizer(uiTapGR)
        profileContainerView.isUserInteractionEnabled = true
        
        // Styling
        // Style borders
        profileContainerView.layer.borderWidth = 1
        profileContainerView.layer.cornerRadius = 10
        profileContainerView.layer.borderColor = UIColor.lightGray.cgColor
        
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.cornerRadius = 10
        logoutButton.layer.borderColor = UIColor.lightGray.cgColor
        
        aboutButton.layer.borderWidth = 1
        aboutButton.layer.cornerRadius = 10
        aboutButton.layer.borderColor = UIColor.lightGray.cgColor
        
        profilePictureField.layer.cornerRadius = 10
        
    }
    
    @objc func showProfileView() {
        // Push to profile view
        let vc = storyboard?.instantiateViewController(identifier: "UITabBarController") as! UITabBarController
        // Access the desired view controller from the viewControllers array
        vc.selectedIndex = 4
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func aboutButtonHandler(_ sender: Any) {
    }
    
    @IBAction func logoutButtonHandler(_ sender: Any) {
        loginSession.logout()
        
        // Push to beginning
        let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = self.navigationController {
            var controllers = navigationController.viewControllers
            
            controllers = controllers.filter { controller in
                return !(controller is LoginViewController)
            }
            
            navigationController.topViewController?.navigationItem.title = "Settings"
            navigationController.viewControllers = controllers
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.topViewController?.navigationItem.title = "Back"
        navigationController?.topViewController?.navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

