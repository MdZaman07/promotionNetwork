//
//  User.swift
//  ios-ass3-promotion-network
//
//  Created by Toan Nguyen on 15/5/2023.
//

import Foundation
import RealmSwift

class AppUser:Object, Identifiable {
    
    @Persisted(primaryKey: true) var _DBid: ObjectId
    @Persisted var id: String
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

    init(id: String, firstName: String, lastName: String, email:String, password: String, city: String, bio: String) {
        self.id = id
        self.firstName =  firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.city = city
        self.bio = bio
    }
    
    // Write to dummy data for now
    func createUser() -> Bool {
//        let dummyDataReader = JSONDummyDataReader()
        //        return dummyDataReader.createUser(newUser: self)
        return false
    }
}
