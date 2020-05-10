//
//  ViewController.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 08/02/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var masukButton: UIButton!
    @IBOutlet weak var daftarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                let myTabbar = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.myTabbar) as! UITabBarController
                self.view.window?.rootViewController = myTabbar
                self.view.window?.makeKeyAndVisible()
            }
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
