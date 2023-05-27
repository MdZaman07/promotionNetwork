//
//  ViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 2/5/23.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // Set navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = self.navigationController {
            var controllers = navigationController.viewControllers
            
            controllers = controllers.filter { controller in
                return !(controller is LoginViewController)
            }
            
            navigationController.topViewController?.navigationItem.title = "About"
            navigationController.topViewController?.navigationItem.hidesBackButton = false
            navigationController.viewControllers = controllers
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}

