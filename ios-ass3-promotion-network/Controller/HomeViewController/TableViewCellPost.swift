//
//  TableViewCellPosts.swift
//  ios-ass3-promotion-network
//
//  Created by Toan Nguyen on 15/5/2023.
//
import Foundation
import UIKit
import GoogleMaps

class TableViewCellPost: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var moneySavedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var post: Post?
    
    func populate(post: Post){
        self.post = post
        let user = post.appUser.first
        guard let user = user else { return }
        profileNameLabel.text = user.firstName + " " + user.lastName
        categoryLabel.text = post.category.rawValue
        moneySavedLabel.text = "$" + String(round(post.moneySaved * 100) / 100)
        descriptionLabel.text = post.text
        likeCountLabel.text = String(post.likes.count)
        
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        setLikes()
        
        selectionStyle = .none

        if !user.profileImageKey.elementsEqual("") {
            AWSManager.shared.getOneImage(key: user.profileImageKey){ [weak self] result in
                switch result{
                case .success (let image):
                    DispatchQueue.main.async {
                        self?.profileImageView.contentMode = .scaleAspectFit
                        self?.profileImageView.image = image
                    }
                case .failure(let error):
                    self?.profileImageView.image = UIImage(systemName: "person.fill")
                    print(error)
                }
            }
        } else {
            profileImageView.image = UIImage(systemName: "person.fill")
        }
        
        
        if post.imageKey.elementsEqual("") {
            // Render Google Map
            let mapView = GMSMapView()
            
            let latitude = Double(post.latitude)
            let longitude = Double(post.longitude)
            
            guard let latitude = latitude, let longitude = longitude else { return }
            
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.5)
            mapView.camera = camera
            
            let marker = GMSMarker()
            marker.position = camera.target
            marker.map = mapView
            
            mapView.settings.tiltGestures = false
            mapView.settings.scrollGestures = false
            mapView.settings.zoomGestures = true
            mapView.settings.rotateGestures = true
            
            mapView.translatesAutoresizingMaskIntoConstraints = false
            
            for view in imageContainer.subviews {
                view.removeFromSuperview()
            }
            
            imageContainer.addSubview(mapView)
            imageContainer.backgroundColor = .none
            
            addConstraintsForSuperview(element: mapView)
        } else {
            // Pull image from AWS S3 bucket
            AWSManager.shared.getOneImage(key: post.imageKey){ [weak self] result in
                switch result{
                case .success (let image):
                    DispatchQueue.main.async {
                        let imageView = UIImageView()
                        imageView.image = image
                        imageView.contentMode = .scaleAspectFit
                        imageView.translatesAutoresizingMaskIntoConstraints = false
                        
                        for view in self!.imageContainer.subviews {
                            view.removeFromSuperview()
                        }
                        
                        self?.imageContainer.addSubview(imageView)
                        self?.imageContainer.backgroundColor = .none
                        self?.addConstraintsForSuperview(element: imageView)
                    }
                case .failure(let error):
                    for view in self!.imageContainer.subviews {
                        view.removeFromSuperview()
                    }
                    print(error)
                }
            }
        }
    }
    
    func addConstraintsForSuperview(element: UIView){
        guard let elementSuperview = element.superview else { return }
        
        element.topAnchor.constraint(equalTo: elementSuperview.topAnchor).isActive = true
        element.bottomAnchor.constraint(equalTo: elementSuperview.bottomAnchor).isActive = true
        element.trailingAnchor.constraint(equalTo: elementSuperview.trailingAnchor).isActive = true
        element.leadingAnchor.constraint(equalTo: elementSuperview.leadingAnchor).isActive = true
    }
    
    @objc func likeButtonPressed(_ sender: UIButton) {
        // Like or unlike the post
        guard let user = getCurrentUser() else { return }
        guard let post = post else { return }
        
        if post.checkUserLike(appUser: user){ //user wants to unlike the picture
            post.unlikePost(appUser: user)
        }
        else{ //user wants to like the picture
            post.likePost(appUser: user)
        }
        
        setLikes()
    }
    
    func setLikes(){
        guard let user = getCurrentUser() else { return }
        guard let post = post else { return }
        
        if post.checkUserLike(appUser: user) {
            likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        }
        
        likeCountLabel.text = String(post.likes.count)
    }
}
