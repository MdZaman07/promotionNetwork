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
    var userNames: [String] = []
    var realmManager = RealmManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        // If there is no login session, push to login screen
        if !isLoginSessionExists() {
            // There is no saved login session or the decoding failed
            print("Login session not found")
            let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        guard let realm = realmManager.realm else { return }
        
        let username = getCurrentUser()?.userName
        userAccounts = Array(realm.objects(AppUser.self)).filter {
            return !$0.userName.elementsEqual(username!)
        }
        
        for userProfile in userAccounts{
            userNames.append(userProfile.userName)
        }
        userAccountsTableView.dataSource = self
        userAccountsTableView.delegate = self
    }
    
    
    @IBAction func handleSearch(_ sender: UITextField) {
        if let searchedText = sender.text {
            let username = getCurrentUser()?.userName

            userAccounts = Array(realmManager.realm!.objects(AppUser.self).filter {
                return (searchedText.elementsEqual("") || $0.userName.lowercased().contains(searchedText.lowercased())) && !$0.userName.elementsEqual(username!)
            })
        }
        userAccountsTableView.reloadData()
                                                                  
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = userAccountsTableView.dequeueReusableCell(withIdentifier: "UserAccountsCell") as! TableViewCellUserAccounts
        let userAccount = self.userAccounts[indexPath.row]
        tableViewCell.profileNameLabel.text = userAccount.userName
        
        if !userAccount.profileImageKey.elementsEqual(""){
            AWSManager.shared.getOneImage(key: userAccount.profileImageKey){ [weak self] result in
                switch result{
                case .success (let image):
                    DispatchQueue.main.async {
                        tableViewCell.profileImageView.contentMode = .scaleAspectFit
                        tableViewCell.profileImageView.image = image
                    }
                case .failure(let error):
                    tableViewCell.profileImageView.image = UIImage(systemName: "person.fill")
                    print(error)
                }
            }
        } else {
            tableViewCell.profileImageView.image = UIImage(systemName: "person.fill")
        }
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "viewProfileSegue", sender: userAccounts[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "viewProfileSegue") {
            let userAccount = sender as! AppUser
            let viewProfile = segue.destination as! ViewProfileViewController
            viewProfile.userProfile = userAccount
        }
    }


}

