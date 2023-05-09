//
//  ViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 2/5/23.
//

import UIKit

class ViewController: UIViewController {
    
    private var realmManager = RealmManager.shared
    
    var firstAppUser = AppUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            do {
                try? await realmManager.initalize()
                firstAppUser.email = "malena@gmail.com"
                firstAppUser.username = "malena"
                
//                if let realm = realmManager.realm{
//                    try! realm.write{
//                       realm.add(firstAppUser)
//                    }
//                }

            }
        }
    }


}

