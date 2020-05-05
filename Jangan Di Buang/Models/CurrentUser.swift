//
//  CurrentUser.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 05/05/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import Foundation

struct CurrentUser {
    let uid: String
    let namadepan: String
    let email: String
    let photoURL: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.namadepan = dictionary["NamaDepan"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.photoURL = dictionary["photoURL"] as? String ?? ""
    }
}
