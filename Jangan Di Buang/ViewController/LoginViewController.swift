//
//  LoginViewController.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 08/02/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var masukButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
        
        Utilities.styleTextField(emailText)
        
        Utilities.styleTextField(passwordText)
        
        Utilities.styleFilledButton(masukButton)
    }
    
    func validateField() -> String? {
        
        if emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Isi Kotak Yang Kosong"
        }
        
        return nil
    }
    
 
    @IBAction func masukTapped(_ sender: Any) {

        let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
        // Login
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            
            if err != nil {
                // Gagal Login
                self.errorLabel.text = err!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                let myTabbar = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.myTabbar) as! UITabBarController
                
                self.view.window?.rootViewController = myTabbar
                self.view.window?.makeKeyAndVisible()
                
            }
        }
    }
    
    @IBAction func kembali(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

