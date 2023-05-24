//
//  ViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 2/5/23.
//

import UIKit

class SearchAccountsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var userAccountsTableView: UITableView!
    
    var loginSession: LoginSession?
    var userAccounts: [AppUser] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // If there is no login session, push to login screen
        if !isLoginSessionExists() {
            // There is no saved login session or the decoding failed
            print("Login session not found")
            let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = userAccountsTableView.dequeueReusableCell(withIdentifier: "userAccountsCell") as! TableViewCellUserAccounts
        
        tableViewCell.profileNameLabel.text = self.userAccounts[indexPath.row].userName
//        if let imageData = userAccounts[indexPath.row].profileImageKey{
//
//        }
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
    
    

   


}

