//
//  LoginViewController.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 08/02/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

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
    
    override func viewDidAppear(_ animated: Bool) {
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.emailText.becomeFirstResponder()
            self.passwordText.becomeFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
 
    @IBAction func masukTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 2.5)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            let email = self.emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = self.passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Login
            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    // Gagal Login
                    if Utilities.isEmailValid(email) == false {
                        if self.emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                            self.passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                            self.errorLabel.text = ("Silahkan Isi Kotak Yang Kosong")
                            self.timerShowKosong()
                            return
                        } else {
                            self.errorLabel.text = ("Email Anda Salah")
                            self.timerShowKosong()
                            return
                        }
                    }
                    if Utilities.isPasswordValid(password) == false {
                        self.errorLabel.text = ("Password Salah")
                        self.timerShowKosong()
                        return
                    }
                } else {
                    self.masukHome()
                }
            }
        }
    }
    
    func masukHome() {
        let myTabbar = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.myTabbar) as! UITabBarController
        self.view.window?.rootViewController = myTabbar
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func kembali(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func timerShowKosong(){
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
            self.errorLabel.text = ""
        }
    }
    
}
