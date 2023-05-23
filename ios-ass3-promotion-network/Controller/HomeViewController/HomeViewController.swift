//
//  ViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 2/5/23.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var postsTableView: UITableView!
    
    var loginSession: LoginSession?
    var posts: [Post] = []
    
    override func viewDidLoad() {
        // If there is no login session, push to login screen
        if !isLoginSessionExists() {
            // There is no saved login session or the decoding failed
            print("Login session not found")
            let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
//        let dummyDataReader = JSONDummyDataReader()
//        self.posts = dummyDataReader.posts
        self.posts = [Post]()
        print("TOAN")
        print(self.posts)
        print("TOAN")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // Amount of rows to render
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.posts.count
    }
    
    // Rendering each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Style the posts
        let tableViewCell = postsTableView.dequeueReusableCell(withIdentifier: "homeTableViewCell") as! TableViewCellPosts
        tableViewCell.postContainer.layer.borderWidth = 1
        tableViewCell.postContainer.layer.cornerRadius = 10
        tableViewCell.postContainer.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor

        tableViewCell.profileName.text = self.posts[indexPath.row].appUser.first?.firstName ?? ""
        //tableViewCell.profileImage
        tableViewCell.locationField.text = self.posts[indexPath.row].address // Change this later to suburb/city
        tableViewCell.categoryLabel.text = self.posts[indexPath.row].category.rawValue
        tableViewCell.descriptionLabel.text = self.posts[indexPath.row].text
        //tableViewCell.likesLabel
        tableViewCell.moneySavedLabel.text = "$\(self.posts[indexPath.row].moneySaved)"
        tableViewCell.addressLabel.text = self.posts[indexPath.row].address
        
        if let imageData = posts[indexPath.row].image {
            let image = UIImage(data: imageData)
            tableViewCell.postImage.image = image
        }
        
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "postSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "postSegue") {
            let indexPath = self.postsTableView.indexPathForSelectedRow!
            
            let post = posts[indexPath.row]
            let viewPost = segue.destination as! ViewPostViewController
            viewPost.post = post            
            self.postsTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}

