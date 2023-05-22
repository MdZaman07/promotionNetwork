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
    
    @Persisted(primaryKey: true) var _id: ObjectId
//    @Persisted var _id: String
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

    required convenience init(text: String, image: Data?, address: String, latitude: String, longitude: String, moneySaved: Double, category: Category) {

        self.init()
        self.text = text
        self.image = image
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.moneySaved = moneySaved
        self.category = category
        self.date = Date.now
        
    }
    
    func createPost() -> Bool {
        guard let appUser = getLoginSession()?.appUser.first else {return false}
        appUser.posts.append(self)
        if let _ = image { //upload image if it exists
            guard uploadPostImage() else { return false}
        }
        let realmManager = RealmManager.shared
        realmManager.createObject(object: self)
        return true
    }
    
    func getPostImageName() ->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY_M_d_HH:mm:ss"
        let dateString = dateFormatter.string(from:date)
        return "\(appUser.first?.userName ?? "")/post/\(dateString)"
    }
    
    func uploadPostImage() -> Bool{
        let awsManager = AWSManager()
        
        guard let imageData = image else {return false}
        guard let uploadImage = UIImage(data: imageData) else {return false}
        
        let pathAndFileName = getPostImageName()
        
        if( !awsManager.uploadImage(image: uploadImage, progress: nil , completion: nil, pathAndFileName: pathAndFileName) ) {
            return false
        }
 
        self.imageKey = pathAndFileName
        
        return true
    }
}
