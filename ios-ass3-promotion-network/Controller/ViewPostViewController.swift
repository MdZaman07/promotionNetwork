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
    
    var name: String!
    var location: String!
    var profileImage: UIImage?
    var image: UIImage?
    var price: String!
    var likes: String?
    var category: String!
    var address: String!
    var desc: String!
    
    
    override func viewDidLoad() {
        nameLabel.text = name
        locationLabel.text = location
        profilePicture.image = profileImage ?? nil
        postImage.image = image ?? nil
        priceLabel.text = price
        likesLabel.text = likes ?? nil
        categoryLabel.text = category
        addressLabel.text = address
        descriptionLabel.text = desc
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

