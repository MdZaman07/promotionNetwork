//
//  LoginSession.swift
//  ios-ass3-promotion-network
//
//  Created by Toan Nguyen on 15/5/2023.
//

import Foundation
import UIKit
import RealmSwift

class LoginSession: Object, Identifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "loginSessions") var appUser: LinkingObjects<AppUser>
    @Persisted var deviceId: String
    var loggedInUser: AppUser!
    private var realmManager = RealmManager.shared
    
    required convenience init(appUser: AppUser) {
        self.init()
        loggedInUser = appUser
        
        // Get current device id (used for auto-login to check if device has already logged in previously)
        deviceId = UIDevice.current.identifierForVendor!.uuidString
        saveLoginSession()
    }
    
    func saveLoginSession() {
        guard let _ = realmManager.realm else {return}
        realmManager.addObjectToList(object: self, list: loggedInUser.loginSessions)
    }
}
