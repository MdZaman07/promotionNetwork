//
//  ProfilePicture.swift
//  ios-ass3-promotion-network
//
//  Created by Toan Nguyen on 15/5/2023.
//

import Foundation

class ProfilePicture {
    var id: String!
    var name: String!
    var imageName: String!
    
    public init(id: String, name: String, imageName: String) {
        self.id = id
        self.name = name
        self.imageName = imageName
    }
}
