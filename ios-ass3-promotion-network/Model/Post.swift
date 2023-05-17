//
//  Post.swift
//  ios-ass3-promotion-network
//
//  Created by Toan Nguyen on 15/5/2023.
//

import Foundation
import UIKit
import RealmSwift

enum Category: String, PersistableEnum, CaseIterable{
    case foodDrinks = "Food and drinks"
    case homewear = "Homewear"
    case personalCare = "Cosmetic/Personal Care"
    case fashion = "Fashion"
}
class Post: Object, Identifiable {
    
    @Persisted(primaryKey: true) var _DBid: ObjectId
    @Persisted var id: String
    @Persisted var text: String
    @Persisted var image: Data?
    @Persisted var address: String
    @Persisted var latitude: String
    @Persisted var longitude: String
    @Persisted var moneySaved: Double
    @Persisted var category: Category
    @Persisted var imageKey: String
    @Persisted var date: Date
    @Persisted(originProperty: "posts") var appUser: LinkingObjects<AppUser>
    @Persisted var likes: List<LikedPost>

    init(text: String, image: Data, address: String, latitude: String, longitude: String, moneySaved: Double, category: Category) {
        // Generate random post id (for now)
        let uuid = UUID()
        let postID = uuid.uuidString
    
        self.id = postID
        self.text = text
        self.image = image
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.moneySaved = moneySaved
        // Not sure if this is meant to be here
        self.category = category
        self.date = Date.now

    }
    
    func createPost() -> Bool {
//        // Save post (dummy data for now)
//        var dummyDataReader = JSONDummyDataReader()
//        return dummyDataReader.createPost(newPost: self)
//
        return false
    }
}
