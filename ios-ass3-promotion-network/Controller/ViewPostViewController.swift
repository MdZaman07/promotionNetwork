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

        if let post = post { //post information always assumed to arrive through the segue
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

            //set map if coordinates are available
            if let longitude = Double(post.longitude), let latitude = Double(post.latitude) {
                setMapLayout(latitude: latitude, longitude: longitude)
            }

            applyBorderStylingToTextViews(fields: [descriptionField]) //round borders off text view
        }

        super.viewDidLoad()
        navigationItem.backButtonTitle = "Back"

    }

    func getPostImage() { //download the post image from AWSS3
        self.postImage.backgroundColor = .clear
        if let post = post, !post.imageKey.elementsEqual("") {
            AWSManager.shared.getOneImage(key: post.imageKey) { [weak self] result in
                switch result {
                case .success (let image):
                    DispatchQueue.main.async {
                        self?.postImage.image = image //in case of success assign it to the postImage view
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        else { //if no image is available, display a camera
            self.postImage.image = UIImage(systemName: "camera.fill")
            self.postImage.tintColor = .systemGray4
        }
    }

    func getProfileImage() { //download the user image from AWSS3
        self.profilePicture.backgroundColor = .clear
        if let user = post?.appUser.first, !user.profileImageKey.elementsEqual("") {
            AWSManager.shared.getOneImage(key: user.profileImageKey) { [weak self] result in
                switch result {
                case .success (let image):
                    DispatchQueue.main.async {
                        self?.profilePicture.image = image //in case of success assign it to the profilePicture view
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        else { //if no image is available, display a camera
            self.profilePicture.image = UIImage(systemName: "person.fill")
            self.profilePicture.tintColor = .systemGray4
        }
    }

    func setLikeImage() { //controls if the user has liked the image
        if let post = post, let user = getCurrentUser(), post.checkUserLike(appUser: user) {
            likedImageDisplay()
        }
        else {
            unlikedImageDisplay()
        }
    }

    func likedImageDisplay() { //filled thumb up display
        likesLabel?.text = String(likesCount)
        likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
    }

    func unlikedImageDisplay() { //unfilled thumb up display
        likesLabel?.text = String(likesCount)
        likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
    }


    //sets the marker and the view of the map at the address of the post
    func setMapLayout(latitude: Double, longitude: Double) {
        let marker = GMSMarker()
        mapView.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = "Selected location"
        marker.map = mapView
    }


    //like function
    @IBAction func likeButtonPressed(_ sender: Any) {
        guard let post = post else { return }
        guard let currentUser = getCurrentUser() else { return }
        if post.checkUserLike(appUser: currentUser) { //user wants to unlike the picture
            post.unlikePost(appUser: currentUser)
            likesCount -= 1
            unlikedImageDisplay()
        }
        else { //user wants to like the picture
            post.likePost(appUser: currentUser)
            likesCount += 1
            likedImageDisplay()
        }
    }

    //shows navigation bar
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

    //hides navigation bar
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

