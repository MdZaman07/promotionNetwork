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
    if let loginSession = UserDefaults.standard.object(forKey: "loginSession") {
        return true
    }
    return false
}

func textFieldErrorAction(field: UITextField, msg: String) {
    print(msg)
    field.layer.borderWidth = 1
    field.layer.borderColor = UIColor.red.cgColor
}
