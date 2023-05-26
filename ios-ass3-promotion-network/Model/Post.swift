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
    case other = "Other"
}

class Post: Object, Identifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
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

    required convenience init(text: String, address: String, latitude: String, longitude: String, moneySaved: Double, category: Category) {

        self.init()
        self.text = text
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.moneySaved = moneySaved
        self.category = category
        self.date = Date.now
    }
    
    func createPost(image:UIImage?, completion:@escaping completionBlock) -> Bool {
        guard let appUser = getCurrentUser() else {return false}
                
        if let image = image{
            guard uploadPostImage(appUser:appUser, image:image, completion:completion) else { return false}
        }
        
        let realmManager = RealmManager.shared
        realmManager.addObjectToList(object: self, list: appUser.posts)

        return true
    }
    
    func getPostImageName(appUser:AppUser) ->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY_M_d_HH:mm:ss"
        let dateString = dateFormatter.string(from:date)
        return "\(appUser.userName)/post/\(dateString)"
    }
    
    
    func uploadPostImage(appUser:AppUser, image:UIImage, completion:@escaping completionBlock) -> Bool{
        
        let awsManager = AWSManager.shared
        
        guard let imageData = image.pngData() else {return false}
        guard let uploadImage = UIImage(data: imageData) else {return false}
        
        let pathAndFileName = getPostImageName(appUser:appUser)
        
        if( !awsManager.uploadImage(image: uploadImage, progress: nil , completion: completion , pathAndFileName: pathAndFileName) ) {
            return false
        }
 
        self.imageKey = pathAndFileName
        
        return true
    }
    
    func checkUserLike(appUser:AppUser) -> Bool{
        if likes.contains(where: {$0.appUser.first?._id == appUser._id}){
            return true
        }
        return false
    }
    
    func likePost(appUser:AppUser){
        let like = LikedPost()
        let realmManager = RealmManager.shared
        
        realmManager.addObjectToList(object: like, list:appUser.likes)
        realmManager.addObjectToList(object: like, list: self.likes)
    
        return
    }
    
    func unlikePost(appUser:AppUser){
        guard let like = likes.first(where: {$0.appUser.first?._id == appUser._id}) else {return}
            
        let realmManager = RealmManager.shared
        realmManager.removeObject(object: like)
    }
    
}
