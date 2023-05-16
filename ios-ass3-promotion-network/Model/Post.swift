//
//  Post.swift
//  ios-ass3-promotion-network
//
//  Created by Toan Nguyen on 15/5/2023.
//

import Foundation

class Post: Codable {
    let id: String
    let user: String
    var text: String
    var image: String
    var address: String
    var latitude: String
    var longitude: String
    var money_saved: Double
    
    init(id: String, user: String, text: String, image: String, address: String, latitude: String, longitude: String, money_saved: Double) {
        self.id = id
        self.user = user
        self.text = text
        self.image = image
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.money_saved = money_saved
    }
}
