//
//  LoginSession.swift
//  ios-ass3-promotion-network
//
//  Created by Toan Nguyen on 15/5/2023.
//

import Foundation
import UIKit
import RealmSwift

// I'm not sure how we're going to do login sessions but I'll use my dummy data method for now
class LoginSession: Object, Identifiable {
    
    @Persisted(primaryKey: true) var _DBid: ObjectId
    @Persisted var id: String
    @Persisted(originProperty: "loginSessions") var appUser: LinkingObjects<AppUser>
    @Persisted var deviceId: String
    
    init(userId: String) {
        // Generate unique login session id
        let uuid = UUID()
        id = uuid.uuidString
        deviceId = UIDevice.current.identifierForVendor!.uuidString
//        saveLoginSession()
    }
    
//    func saveLoginSession() {
//        do {
//            let encodedSession = try JSONEncoder().encode(self)
//            UserDefaults.standard.set(encodedSession, forKey: "loginSession")
//            print("Login session saved successfully")
//        } catch {
//            print("Error saving login session: \(error)")
//        }
//    }
}
