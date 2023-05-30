//
//  ViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 2/5/23.
//

import UIKit

class ViewProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var numberOfPostsLabel: UILabel!
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var numberOfFollowingLabel: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var userCityLabel: UILabel!
    @IBOutlet weak var profileBioLabel: UILabel!
    @IBOutlet weak var userPostsTableView: UITableView!
    
    @IBOutlet weak var editOrFollowButton: UIButton!
    var userProfile: AppUser?
    var loginSession: LoginSession?
    var posts: [Post] = []
    var realmManager = RealmManager.shared
    var isLoggedInUser: Bool = false
    var isFollowing: Bool = false
    var userFollowing: UserFollow?
    let loggedInUser = getCurrentUser()
    
    

    
    override func viewDidLoad() {
        // If there is no login session, push to login screen
        if !isLoginSessionExists() {
            // There is no saved login session or the decoding failed
            print("Login session not found")
            let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if userProfile == nil{
            userProfile = loggedInUser
        }
        
        checkUser()
        setInitialButtonText()
        checkFollowing()
        
        super.viewDidLoad()
        userPostsTableView.dataSource = self
        userPostsTableView.delegate = self
    }
    
    func setUserInfo(){

        if !userProfile!.profileImageKey.elementsEqual(""){
            AWSManager.shared.getOneImage(key: userProfile!.profileImageKey){ [weak self] result in
                switch result{
                case .success (let image):
                    DispatchQueue.main.async {
                        self!.profileImageView.contentMode = .scaleAspectFit
                        self!.profileImageView.image = image
                    }
                case .failure(let error):
                    self!.profileImageView.image = UIImage(systemName: "person.fill")
                    print(error)
                }
            }
        } else {
            profileImageView.image = UIImage(systemName: "person.fill")
        }
        numberOfPostsLabel.text = "\(userProfile!.posts.count)"
        numberOfFollowersLabel.text = "\(userProfile!.followers.count)"
        numberOfFollowingLabel.text = "\(userProfile!.following.count)"
        profileNameLabel.text = userProfile!.firstName + " " + userProfile!.lastName + " |"
        userCityLabel.text = userProfile!.city
        profileBioLabel.text = userProfile!.bio
    }
    
    func checkUser(){
        guard userProfile == loggedInUser else{
            isLoggedInUser = false
            return
        }
        isLoggedInUser = true
    }
    func setInitialButtonText(){
        if(isLoggedInUser){
            editOrFollowButton.setTitle("Edit Account", for: .normal)
            editOrFollowButton.backgroundColor = .gray
           // editOrFollowButton.layer.cornerRadius = 5
            editOrFollowButton.tintColor = .black
        }
        else{
          //  editOrFollowButton.setTitle("Follow", for: .normal)
            editOrFollowButton.backgroundColor = .blue
            editOrFollowButton.tintColor = .white
        }
    }
    func checkFollowing(){
        guard !isLoggedInUser else{return}
        for loggedInUserFollow in loggedInUser!.following{
            if(loggedInUserFollow.followee.first?.userName == userProfile?.userName){
                isFollowing = true
                userFollowing = loggedInUserFollow
            }
        }
        guard userFollowing != nil else{
            editOrFollowButton.setTitle("Follow", for: .normal)
            return
        }
        editOrFollowButton.setTitle("Unfollow", for: .normal)
    }
    
    @IBAction func handleButtonAction(_ sender: Any) {
        guard !isLoggedInUser else{
            //edit account functionality
            let vc = storyboard?.instantiateViewController(identifier: "CreateProfileViewController") as! CreateProfileViewController
            vc.isEdit = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        guard let currentUserFollowing = userFollowing else{
            let userFollow = UserFollow()
            let realm = realmManager.realm
            try!realm!.write {
                realm!.add(userFollow)
                userProfile!.followers.append(userFollow)
                loggedInUser!.following.append(userFollow)
            }
            checkFollowing()
            numberOfFollowersLabel.text = "\(userProfile!.followers.count)"
            return
        }
        realmManager.removeObject(object: currentUserFollowing)
        userFollowing = nil
        numberOfFollowersLabel.text = "\(userProfile!.followers.count)"
        checkFollowing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userProfile?.posts.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userPostCell = tableView.dequeueReusableCell(withIdentifier: "userPostCell", for: indexPath) as! TableViewCellUserPost
        userPostCell.populate(post: (userProfile?.posts[indexPath.row])!)
        return userPostCell
        
    }


    // Set navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserInfo()

        if let navigationController = self.navigationController {
            var controllers = navigationController.viewControllers
            
            controllers = controllers.filter { controller in
                return !(controller is LoginViewController)
            }
            
            navigationController.topViewController?.navigationItem.title = "View Profile"
            navigationController.viewControllers = controllers
            navigationController.setNavigationBarHidden(false, animated: animated)
            
            // If is the current logged in user, show the settings button
            if(isLoggedInUser) {
                let gearButton = UIBarButtonItem(image: UIImage(named: "gearshape.fill"), style: .plain, target: self, action: #selector(self.settingsButtonHandler))
                gearButton.title = "Settings"
                navigationController.navigationBar.topItem?.rightBarButtonItem = gearButton
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.topViewController?.navigationItem.title = "Back"
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func settingsButtonHandler() {
        let vc = storyboard?.instantiateViewController(identifier: "SettingsViewController") as! SettingsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

