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
    
    func queryUser(field: String, value: String) -> AppUser? {
        guard let _ = realmManager.realm else {return nil}
        return realmManager.getObject(type: AppUser.self, field: field, value: value) as? AppUser
    }
    
    func createUser(profilePicture: UIImage?) -> Bool {
        guard let _ = realmManager.realm else {return false}
        
        // Check if username already exists
        let usernameQueryResult = realmManager.getObject(type: AppUser.self, field: "userName", value: self.userName) as? AppUser

        if let _ = queryUser(field: "userName", value: self.userName) {
            print("Username already exists")
            return false
        }
        
        // Check if email already exists
        let emailQueryResult = realmManager.getObject(type: AppUser.self, field: "email", value: self.email) as? AppUser
        
        if let _ = queryUser(field: "email", value: self.email) {
            print("Email already exists")
            return false
        }
        
        // If profile picture is selected in create user view
        if let uploadProfilePicture = profilePicture {
            if( uploadProfilePictureToS3(uploadProfilePicture) ) {
                self.profileImageKey = "\(userName)/profilePicture"
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
        guard let realm = realmManager.realm else {return false}
        let awsManager = AWSManager()

        realm.beginWrite()
        self.profileImageKey = "\(userName)/profilePicture"
        try! realm.commitWrite()
        return awsManager.uploadImage(image: profilePicture, progress: nil , completion: nil, pathAndFileName: self.profileImageKey)
    }
    
    func updateAccount(profilePicture: UIImage?, fieldValues: Dictionary<String, String>) -> Bool {
        guard let realm = realmManager.realm else {return false}
        
        // Update profile picture if it isn't nil
        if let profilePicture = profilePicture {
            if(!uploadProfilePictureToS3(profilePicture)) {
                print("Error uploading picture")
            }
        }
        
        // Update user properties if they're different
        if let user = realm.object(ofType: AppUser.self, forPrimaryKey: _id) {
            for field in fieldValues {
                if(self[field.key] as! String != field.value) {
                    // Skip iteration if password is different but is empty
                    if(field.key == "password" && field.value == "") {
                        continue
                    }
                    
                    // Check if the email or username already exists
                    if(field.key == "email" || field.key == "userName") {
                        if let _ = queryUser(field: field.key, value: field.value) {
                            print("\(field.key) already exists")
                            return false
                        }
                    }
                    
                    realm.beginWrite()
                    user[field.key] = field.value
                    try! realm.commitWrite()
                
                }
            }
        }
        return true
    }
}
