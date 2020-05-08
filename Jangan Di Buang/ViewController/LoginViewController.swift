//
//  LoginViewController.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 08/02/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController{
    
    @IBOutlet weak var emailText: UITextField!{
        didSet{
            emailText.setRightView(image: UIImage.init(named: "icons8-email-100")!)
            emailText.tintColor = .darkGray
        }
    }
    
    @IBOutlet weak var passwordText: UITextField!{
        didSet{
            passwordText.setRightView(image: UIImage.init(named: "icons8-password-100")!)
            passwordText.tintColor = .darkGray
        }
    }
    
    @IBOutlet weak var masukButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var viewMasuk: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        masukButton.layer.cornerRadius = 15.00
        viewMasuk.layer.cornerRadius = 10.00
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
                if Utilities.isEmailValid(email) == false {
                    self.errorLabel.text = ("Email Anda Salah Format")
                    return
                }
                if Utilities.isPasswordValid(password) == false {
                    self.errorLabel.text = ("Password Salah")
                    return
                }
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
