//
//  ProfilViewController.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 22/02/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfilViewController: UIViewController {
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func LogoutTapped(_ sender: Any) {
        
        // Logout
        
        let auth = Auth.auth()
        
        do {
            try auth.signOut()
        } catch _ {
            print("error")
        }
        
        let signoutVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.VC) as! UINavigationController
        
        self.view.window?.rootViewController = signoutVC
        self.view.window?.makeKeyAndVisible()
        
    }
}
