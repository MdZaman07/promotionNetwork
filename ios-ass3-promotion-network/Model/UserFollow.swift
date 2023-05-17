//
//  UserFollow.swift
//  ios-ass3-promotion-network
//
//  Created by Toan Nguyen on 15/5/2023.
//

import Foundation
import RealmSwift

class UserFollow:Object, Identifiable {
    @Persisted(primaryKey: true) var _DBid: ObjectId
    @Persisted(originProperty: "following") var follower: LinkingObjects<AppUser>
    @Persisted(originProperty: "followers") var followee: LinkingObjects<AppUser>
}

