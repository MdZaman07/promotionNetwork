//
//  User.swift
//  ios-ass3-promotion-network
//
//  Created by Toan Nguyen on 15/5/2023.
//

import Foundation

class NetUser: Codable {
    let id: String
    var firstName: String
    var lastName: String
    var password: String
    var city: String
    var description: String
    
    init(id: String, firstName: String, lastName: String, password: String, city: String, description: String) {
        self.id = id
        self.firstName =  firstName
        self.lastName = lastName
        self.password = password
        self.city = city
        self.description = description
    }
    
    
    // Write to dummy data for now
    func createUser() -> Bool {
        var dummyDataReader = JSONDummyDataReader()
        return dummyDataReader.createUser(newUser: self)
    }
}
