//
//  LikedPost.swift
//  ios-ass3-promotion-network
//
//  Created by Toan Nguyen on 15/5/2023.
//

import Foundation
import RealmSwift

class LikedPost:Object, Identifiable {
    @Persisted(primaryKey: true) var _DBid: ObjectId
    @Persisted(originProperty: "likes") var appUser: LinkingObjects<AppUser>
    @Persisted(originProperty: "likes") var post: LinkingObjects<Post>
}
