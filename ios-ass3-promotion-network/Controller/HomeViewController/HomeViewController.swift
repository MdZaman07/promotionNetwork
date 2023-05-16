//
//  ViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 2/5/23.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var postsTableView: UITableView!
    
    var profilePictureList = [ProfilePicture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initList()
    }
    
    func initList() {
        let profilePicCirc = ProfilePicture(id: "0", name: "Circle", imageName: "circle")
        profilePictureList.append(profilePicCirc)
        let profilePicTri = ProfilePicture(id: "1", name: "Triangle", imageName: "triangle")
        profilePictureList.append(profilePicTri)
        let profilePicSquare = ProfilePicture(id: "0", name: "Square", imageName: "square")
        profilePictureList.append(profilePicSquare)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return profilePictureList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = postsTableView.dequeueReusableCell(withIdentifier: "homeTableViewCell") as! TableViewCellPosts
        
        let thisPic = profilePictureList[indexPath.row]
        tableViewCell.profileName.text = thisPic.id + " " + thisPic.name
        tableViewCell.profileImage.image = UIImage(named: thisPic.imageName)
        
        tableViewCell.postContainer.layer.borderWidth = 1
        tableViewCell.postContainer.layer.cornerRadius = 10
        tableViewCell.postContainer.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor

        
        return tableViewCell
    }
}

