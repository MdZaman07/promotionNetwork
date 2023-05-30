//
//  ViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Pulok Uz Zaman on 2/5/23.
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
        //get all the users from the database
        userAccounts = Array(realm.objects(AppUser.self))
        for userProfile in userAccounts{ //add all the users' username tp the userNames variable
            userNames.append(userProfile.userName)
        }
        userAccountsTableView.dataSource = self
        userAccountsTableView.delegate = self
    }
    
    @IBAction func handleSearch(_ sender: UITextField) { //handles search everytime the textField is edited
        guard let realm = realmManager.realm else { return }
        if let searchedText = sender.text{
            guard !searchedText.isEmpty else{ //if searchedTet is empty, assign all the users in the database to userAccounts
                userAccounts = Array(realm.objects(AppUser.self))
                userAccountsTableView.reloadData()
                return
            }
            //search filter is case insensitive
            userAccounts = Array(realm.objects(AppUser.self).filter { $0.userName.lowercased().contains(searchedText.lowercased()) })
        }
        userAccountsTableView.reloadData() //reload tableView with the matched userAccounts
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
        performSegue(withIdentifier: "viewProfileSegue", sender: userAccounts[indexPath.row]) // show the profile of the selected user
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "viewProfileSegue") {
            let userAccount = sender as! AppUser
            let viewProfile = segue.destination as! ViewProfileViewController
            //assign the selected userAccount to the userProfile variable in viewProfile
            viewProfile.userProfile = userAccount
        }
    }

}

