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
    var userProfile: AppUser?
    var loginSession: LoginSession?
    var posts: [Post] = []
    var realmManager = RealmManager.shared
    
    
    
    

    override func viewDidLoad() {
        // If there is no login session, push to login screen
        if !isLoginSessionExists() {
            // There is no saved login session or the decoding failed
            print("Login session not found")
            let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if userProfile == nil{
            userProfile = getCurrentUser()
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
        profileNameLabel.text = userProfile!.firstName + " " + userProfile!.lastName
        userCityLabel.text = userProfile!.city
        profileBioLabel.text = userProfile!.bio
        
        // Retrieve list of posts
//        guard let realm = realmManager.realm else { return }
//        posts = Array(realm.objects(Post.self))

        // TODO: Order them to display post of followed users first
        
        
        super.viewDidLoad()
        userPostsTableView.dataSource = self
        userPostsTableView.delegate = self
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

