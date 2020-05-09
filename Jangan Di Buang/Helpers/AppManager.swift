//
//  AppManager.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 09/05/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import UIKit
import Firebase

class AppManager {
    
    static let shared = AppManager()
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var landingController: ViewController!
    
    private init() {
        
    }
    
    func showApp() {
        
        var viewController: UIViewController
        
        if Auth.auth().currentUser != nil {
            viewController = storyboard.instantiateViewController(withIdentifier: "myTabbar")
        } else {
            viewController = storyboard.instantiateViewController(withIdentifier: "VC") as! ViewController
        }

        landingController.present(viewController, animated: true, completion: nil)

    }
    
    func logout() {
        try! Auth.auth().signOut()
        landingController.presentedViewController?.dismiss(animated: true, completion: nil)

    }
    
}
