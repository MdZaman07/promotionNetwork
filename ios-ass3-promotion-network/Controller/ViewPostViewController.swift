//
//  ViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 2/5/23.
//

import UIKit
import Foundation
import GoogleMaps

class ViewPostViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var mapView: GMSMapView!
    
    var post: Post?

    override func viewDidLoad() {
        if let post = post{
            nameLabel.text = post.appUser.first?.userName
            locationLabel.text = post.appUser.first?.city
            priceLabel.text = String(post.moneySaved)
            likesLabel.text = String(post.likes.count)
            categoryLabel.text = post.category.rawValue
            addressLabel.text = post.address
            descriptionField.text = post.text
            
            getPostImage(key:post.imageKey)
            
            if let profileImage = post.appUser.first?.profileImageKey{
                getProfileImage(key: profileImage)
            }

            if let longitude =  Double(post.longitude), let latitude = Double(post.latitude){
                setMapLayout(latitude: latitude, longitude: longitude)
            }
            
            applyBorderStylingToTextViews(fields: [descriptionField])
        }

        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func getPostImage(key:String){

        AWSManager.shared.getOneImage(key:key){ [weak self] result in
            switch result{
            case .success (let image):
                DispatchQueue.main.async {
                    self?.postImage.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func getProfileImage(key:String){

        AWSManager.shared.getOneImage(key:key){ [weak self] result in
            switch result{
            case .success (let image):
                DispatchQueue.main.async {
                    self?.profilePicture.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setMapLayout(latitude: Double, longitude:Double){
        let marker = GMSMarker()
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
        marker.position = CLLocationCoordinate2D(latitude:latitude,longitude: longitude)
        marker.title = "Selected location"
        marker.map = mapView
    }
}

