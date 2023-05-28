//
//  ViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 2/5/23.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    @IBOutlet weak var tableView: UITableView!
    
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
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Retrieve list of posts
        guard let realm = realmManager.realm else { return }
        var allPosts = Array(realm.objects(Post.self))
        
        guard let user = LoginSession.currentUser else {
            posts = allPosts
            print("No logged in user")
            return
        }

        // Order by date
        allPosts.sort {
            $0.date > $1.date
        }
        
        // Create two arrays, one for storing followed accounts' posts, one for the rest
        var followedPosts: [Post] = []
        var rest: [Post] = []
        
        for post in allPosts {
            if user.following.contains(where: { userFollow in
                return post.appUser[0].email.elementsEqual(userFollow.followee[0].email)
            }) {
                followedPosts.append(post)
            } else {
                rest.append(post)
            }
        }
        
        // Append the followed array with the rest
        followedPosts.append(contentsOf: rest)
        posts = followedPosts
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postCell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! TableViewCellPost
        postCell.populate(post: posts[indexPath.row])
        return postCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewPostViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewPostViewController") as! ViewPostViewController
        viewPostViewController.post = posts[indexPath.row]
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewPostViewController, animated: true)
        }
    }
}

