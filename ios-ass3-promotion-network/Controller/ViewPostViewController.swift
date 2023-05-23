//
//  ViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 2/5/23.
//

import UIKit
import Foundation

class ViewPostViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var post: Post?

    override func viewDidLoad() {
        if let post = post{
            nameLabel.text = post.appUser.first?.userName
            locationLabel.text = post.address
            priceLabel.text = String(post.moneySaved)
            likesLabel.text = String(post.likes.count)
            categoryLabel.text = post.category.rawValue
            addressLabel.text = post.address
            descriptionLabel.text = post.description
            if let image = post.image{
                self.postImage.image = UIImage(data: image)
            }
            //getPostImage(key:post.imageKey)
            //setMapLayout()
        }

        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//    func getPostImage(key:String){
//        let aws3 = AWSManager()
//        if let image = aws3.getOneImage(key: key){
//            self.postImage.image = image
//        }
//    }
    
//    func setMapLayout(){
//
//    }
}

