//
//  User.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 9/5/23.
//

import Foundation
import RealmSwift

class AppUser: Object, Identifiable{
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var username: String = ""
    @Persisted var email: String = ""
    
}
