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
    var profilePictureList = [ProfilePicture]()
    
    override func viewDidLoad() {
        // If there is no login session, push to login screen
        if let encodedSession = UserDefaults.standard.data(forKey: "loginSession") {
            do {
                let decodedSession = try JSONDecoder().decode(LoginSession.self, from: encodedSession)

                // The savedSession is now of type LoginSession and you can use it
                self.loginSession = decodedSession
                print("Successfully logged in user: \(self.loginSession!.user)")
            } catch {
                print("Error decoding login session: \(error)")
            }

        } else {
            // There is no saved login session or the decoding failed
            print("Login session not found")
            let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
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

