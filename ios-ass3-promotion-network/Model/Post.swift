//
//  Post.swift
//  ios-ass3-promotion-network
//
//  Created by Toan Nguyen on 15/5/2023.
//

import Foundation
import UIKit

class Post: Codable {
    let id: String
    let user: String
    var text: String
    var image: Data?
    var address: String
    var latitude: String
    var longitude: String
    var moneySaved: Double
    var category: String
    
    init(user: String, text: String, image: Data, address: String, latitude: String, longitude: String, moneySaved: Double, category: String) {
        // Generate random post id (for now)
        let uuid = UUID()
        let postID = uuid.uuidString
        
        self.id = postID
        self.user = user
        self.text = text
        self.image = image
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.moneySaved = moneySaved
        
        // Not sure if this is meant to be here
        self.category = category
    }
    
    func createPost() -> Bool {
        // Save post (dummy data for now)
        var dummyDataReader = JSONDummyDataReader()
        return dummyDataReader.createPost(newPost: self)
    }
}
