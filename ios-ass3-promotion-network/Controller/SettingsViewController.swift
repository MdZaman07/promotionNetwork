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
    }

    
    @IBAction func aboutButtonHandler(_ sender: Any) {
    }
    
    @IBAction func logoutButtonHandler(_ sender: Any) {
    }
}

