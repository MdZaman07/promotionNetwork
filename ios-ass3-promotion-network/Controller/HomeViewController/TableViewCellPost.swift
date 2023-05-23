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
    
    func populate(post: Post){
        let user = post.appUser.first
        guard let user = user else { return }
        profileNameLabel.text = user.firstName + " " + user.lastName
        categoryLabel.text = post.category.rawValue
        moneySavedLabel.text = "$" + String(round(post.moneySaved * 100) / 100)
        descriptionLabel.text = post.text
        
        selectionStyle = .none

        // Todo
        let profileImage: UIImage? = nil
        let postImage: UIImage? = nil
        
        if postImage == nil {
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
            
            imageContainer.addSubview(mapView)
            
            guard let mapSuperview = mapView.superview else { return }
            
            mapView.topAnchor.constraint(equalTo: mapSuperview.topAnchor).isActive = true
            mapView.bottomAnchor.constraint(equalTo: mapSuperview.bottomAnchor).isActive = true
            mapView.trailingAnchor.constraint(equalTo: mapSuperview.trailingAnchor).isActive = true
            mapView.leadingAnchor.constraint(equalTo: mapSuperview.leadingAnchor).isActive = true
            
        } else {
            // Pull image from AWS S3 bucket
        }
    }
}
