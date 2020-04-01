//
//  Constants.swift
//  Message Me
//
//  Created by Apple on 29.03.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import Firebase
import FirebaseDatabase
import FirebaseStorage

let REF_USERS = Database.database().reference(withPath: "users")
let REF_USER_USERNAMES = Database.database().reference(withPath: "usernames")
let REF_MESSAGES = Database.database().reference(withPath: "messages")
let REF_USER_MESSAGES = Database.database().reference(withPath: "user-messages")
