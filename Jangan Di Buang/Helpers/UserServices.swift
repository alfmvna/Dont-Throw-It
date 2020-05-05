//
//  UserServices.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 05/05/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import Foundation
import Firebase

class UserServices{

    static var currentUserProfile:UserProfile?
    
    static func observeUserProfile(_ uid:String, completion: @escaping ((_ userProfile:UserProfile?)->())) {
        let userRef = Database.database().reference().child("users/profile/\(uid)")
        
        userRef.observe(.value, with: { snapshot in
            var userProfile:UserProfile?
            
            if let dict = snapshot.value as? [String:Any],
                let username = dict["username"] as? String,
                let photoURL = dict["photoURL"] as? String,
                let email = dict["email"] as? String,
                let url = URL(string: photoURL) {
                    
                userProfile = UserProfile(uid: snapshot.key , username: username, email: email, photoURL: url)
            }
            
            completion(userProfile)
        })
    }
}
