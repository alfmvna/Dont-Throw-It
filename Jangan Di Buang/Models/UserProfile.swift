//
//  UserProfile.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 05/05/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import Foundation

struct UserProfile{
    var uid:String
    var username:String
    var email:String
    var photoURL:URL
    
    init(uid:String, username:String, email:String, photoURL:URL) {
        self.uid = uid
        self.username = username
        self.email = email
        self.photoURL = photoURL
    }
}
