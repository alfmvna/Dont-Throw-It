//
//  SignUpViewController.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 08/02/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var namadepanText: UITextField!
    
    @IBOutlet weak var namabelakangText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var daftarButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        
        Utilities.styleTextField(namadepanText)
        
        Utilities.styleTextField(namabelakangText)
        
        Utilities.styleTextField(emailText)
        
        Utilities.styleTextField(passwordText)
        
        Utilities.styleFilledButton(daftarButton)
    }
    
    func validateFields() -> String? {
        
        if namadepanText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            namabelakangText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Isi Kotak Yang Kosong"
        }
        
        let cleanedPassword = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
           return "Password Wajib 6 Character, Huruf Besar, Angka Atau Simbol"
        }
        
        return nil
    }

    @IBAction func daftarTapped(_ sender: Any) {
        
        // Validasi
        
        let error = validateFields()
        
        if error != nil {
            showError("")
        } else {

        // Cleaned Version
        let namadepan = namadepanText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let namabelakang = namabelakangText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
        // Buat User
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            // Check Error
            if err != nil {
                self.showError("Pembuatan Akun Error")
            }
            else {
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["NamaDepan":namadepan, "NamaBelakang":namabelakang, "Email":email, "Password":password, "uid": result!.user.uid ]) { (error) in
                        if error != nil {
                            // Show error message
                            self.showError("Penyimpanan Akun Error")
                        }
                    }
                self.transitionToHome()
                }
            }
        }
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {

        let myTabbar = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.myTabbar) as! UITabBarController
        
        self.view.window?.rootViewController = myTabbar
        self.view.window?.makeKeyAndVisible()
    }
    
}
