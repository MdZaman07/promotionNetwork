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
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var mapView: GMSMapView!
    
    var post: Post?
    var likesCount = 0

    override func viewDidLoad() {
        if let post = post{
            nameLabel.text = post.appUser.first?.userName
            locationLabel.text = post.appUser.first?.city
            priceLabel.text = String(post.moneySaved)
            likesCount = post.likes.count
            categoryLabel.text = post.category.rawValue
            addressLabel.text = post.address
            descriptionField.text = post.text
    
            
            getPostImage()
            getProfileImage()
            setLikeImage()
            
            if let longitude =  Double(post.longitude), let latitude = Double(post.latitude){
                setMapLayout(latitude: latitude, longitude: longitude)
            }
            
            applyBorderStylingToTextViews(fields: [descriptionField])
        }

        super.viewDidLoad()
        navigationItem.backButtonTitle = "Back"

    }
    
    func getPostImage(){
        self.postImage.backgroundColor = .clear
        if let post = post, !post.imageKey.elementsEqual(""){
            AWSManager.shared.getOneImage(key:post.imageKey){ [weak self] result in
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
        else{
            self.postImage.image = UIImage(systemName: "camera.fill")
            self.postImage.tintColor = .systemGray4
        }
    }

    func getProfileImage(){
        self.profilePicture.backgroundColor = .clear
        if let user = post?.appUser.first, !user.profileImageKey.elementsEqual(""){
            AWSManager.shared.getOneImage(key:user.profileImageKey){ [weak self] result in
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
         else{
             self.profilePicture.image = UIImage(systemName: "person.fill")
             self.profilePicture.tintColor = .systemGray4
         }
    }
    
    func setLikeImage(){
        if let post = post, let user = getCurrentUser(), post.checkUserLike(appUser: user){
            likedImageDisplay()
        }
        else{
            unlikedImageDisplay()
        }
    }
    
    func likedImageDisplay(){
        likesLabel?.text = String(likesCount)
        likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
    }
    
    func unlikedImageDisplay(){
        likesLabel?.text = String(likesCount)
        likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
    }
    
    
    func setMapLayout(latitude: Double, longitude:Double){
        let marker = GMSMarker()
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
        marker.position = CLLocationCoordinate2D(latitude:latitude,longitude: longitude)
        marker.title = "Selected location"
        marker.map = mapView
    }
    
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        guard let post = post else{return}
        guard let currentUser = getCurrentUser() else{return}
        if post.checkUserLike(appUser:currentUser){ //user wants to unlike the picture
            post.unlikePost(appUser:currentUser)
            likesCount -= 1
            unlikedImageDisplay()
        }
        else{ //user wants to like the picture
            post.likePost(appUser:currentUser)
            likesCount += 1
            likedImageDisplay()
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = self.navigationController {
            var controllers = navigationController.viewControllers
            
            controllers = controllers.filter { controller in
                return !(controller is LoginViewController)
            }
            
            navigationController.topViewController?.navigationItem.title = "View Post"
            navigationController.viewControllers = controllers
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

