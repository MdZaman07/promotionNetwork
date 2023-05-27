//
//  ViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 2/5/23.
//

import UIKit

class ViewProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
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
        
        // Retrieve list of posts
//        guard let realm = realmManager.realm else { return }
//        posts = Array(realm.objects(Post.self))

        // TODO: Order them to display post of followed users first
        checkUser()
        setInitialButtonText()
        checkFollowing()
        
        super.viewDidLoad()
        userPostsTableView.dataSource = self
        userPostsTableView.delegate = self
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


}

