//
//  User.swift
//  ios-ass3-promotion-network
//
//  Created by Toan Nguyen on 15/5/2023.
//

import Foundation
import RealmSwift

class AppUser:Object, Identifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var userName: String
    @Persisted var firstName: String
    @Persisted var lastName: String
    @Persisted var email: String
    @Persisted var password: String
    @Persisted var city: String
    @Persisted var bio: String
    @Persisted var profileImageKey: String
    @Persisted var posts: List<Post>
    @Persisted var likes: List<LikedPost>
    @Persisted var followers: List<UserFollow>
    @Persisted var following: List<UserFollow>
    @Persisted var loginSessions: List<LoginSession>
    private var realmManager = RealmManager.shared

    required convenience init(userName: String, firstName: String, lastName: String, email:String, password: String, city: String, bio: String) {
        self.init()
        self.userName = userName
        self.firstName =  firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.city = city
        self.bio = bio
        self.loginSessions = List<LoginSession>()
    }
    
    func createUser(profilePicture: UIImage?) -> Bool {
        guard let realm = realmManager.realm else {return false}
        
        // Check if username already exists
        let usernameQueryResult = realm.objects(AppUser.self).filter("userName == %@", self.userName).first
        if(usernameQueryResult != nil) {
            print("Username already exists")
            return false
        }
        
        // Check if email already exists
        let emailQueryResult = realm.objects(AppUser.self).filter("email == %@", self.email).first
        
        if(emailQueryResult != nil) {
            print("Email already exists")
            return false
        }
        
        // If profile picture is selected in create user view
        if let uploadProfilePicture = profilePicture {
            if( uploadProfilePictureToS3(uploadProfilePicture) ) {
                print("Uploaded profile picture successfully to S3!")
            } else {
                print("Something went wrong uploading profile picture")
                return false
            }
        }
        
        // Write new user to database
        realmManager.createObject(object: self)
        
        return true
    }
    
    func uploadProfilePictureToS3(_ profilePicture: UIImage) -> Bool {
        let awsManager = AWSManager()
        
        if( !awsManager.uploadImage(image: profilePicture, progress: nil , completion: nil, pathAndFileName: self.profileImageKey) ) {
            return false
        }
        
        self.profileImageKey = "\(userName)/profilePicture"
        
        return true
    }
}
