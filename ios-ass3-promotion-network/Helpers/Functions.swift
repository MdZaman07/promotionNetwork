//
//  Functions.swift
//  ios-ass3-promotion-network
//
//  Created by Toan Nguyen on 17/5/2023.
//

import Foundation
import UIKit

func getLoginSession() -> LoginSession? {
//    if let encodedSession = UserDefaults.standard.data(forKey: "loginSession") {
//        do {
//            let decodedSession = try JSONDecoder().decode(LoginSession.self, from: encodedSession)
//
//            return(decodedSession)
//        } catch {
//            print("Error decoding login session: \(error)")
//        }
//    }
    return nil
}

func isLoginSessionExists() -> Bool {
    let realmManager = RealmManager.shared
    guard let _ = realmManager.realm else {return false}
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    
    if let _ = realmManager.getObject(type: LoginSession.self, field: "deviceId", value: deviceId) as? LoginSession{
        return true
    }
    return false
    
//    return loginSession
//    if let loginSession = UserDefaults.standard.object(forKey: "loginSession") {
//        return true
//    }
//    return false
}

func textFieldErrorAction(field: UITextField, msg: String) {
    field.text = ""
    field.layer.borderWidth = 1
    field.layer.borderColor = UIColor.red.cgColor
    field.attributedPlaceholder = NSAttributedString(
        string: msg,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
    )
}
    

// Helper function to make text fields grey and add corner radius
func applyBorderStylingToTextFields(fields: [UITextField]) {
    for field in fields {
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.masksToBounds = true
    }
}
