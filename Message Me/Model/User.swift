//
//  User.swift
//  Message Me
//
//  Created by Apple on 29.03.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
// everything we upload to database regarding to our user.

import Foundation

struct User {
    let uid: String!
    var profileImageUrl: String
    var username: String
    var fullname: String
    var email: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
    
}
