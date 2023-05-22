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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
    
    @IBAction func aboutButtonHandler(_ sender: Any) {
    }
    
    @IBAction func logoutButtonHandler(_ sender: Any) {
    }
}

