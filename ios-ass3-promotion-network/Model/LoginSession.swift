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
    
    // Delete login session
    func logout() {
        guard let _ = realmManager.realm else {return}
        realmManager.removeObject(object: self)
    }
    
    // Static function to query Realm for a login session of the current device if it exists
    static func getLoginSession() -> LoginSession? {
        let realmManager = RealmManager.shared
        guard let realm = realmManager.realm else {return nil}
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        let loginSession = realm.objects(LoginSession.self).filter("deviceId == %@", deviceId).first
        return loginSession
    }
}
