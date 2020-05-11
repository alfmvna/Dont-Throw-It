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
    @IBOutlet weak var checkBox: UIButton!
    
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
    
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
 
    @IBAction func masukTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        self.loading()
        
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
                            self.silahkanisi()
                            return
                        } else {
                            self.emailSalah()
                            return
                        }
                    }
                    if Utilities.isPasswordValid(password) == false {
                        self.passwordSalah()
                        return
                    }
                } else {
                    self.masukHome()
                    self.loading()
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
    
}

extension LoginViewController{
    func loading(){
        let hud = JGProgressHUD(style: .dark)
        
        hud.show(in: self.view)
        
        hud.vibrancyEnabled = true
        hud.textLabel.text = "Loading"
        hud.layoutMargins = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
    }
    
    func silahkanisi(){
        let hud = JGProgressHUD(style: .dark)
        
        hud.show(in: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            UIView.animate(withDuration: 0.3) {
                hud.indicatorView = nil
                hud.textLabel.font = UIFont.systemFont(ofSize: 15.0)
                hud.textLabel.text = ("Silahkan Isi Yang Kosong")
                hud.position = .center
            }
        }
        hud.dismiss(afterDelay: 3.0)
    }
    
    func emailSalah(){
        let hud = JGProgressHUD(style: .dark)
        
        hud.show(in: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            UIView.animate(withDuration: 0.3) {
                hud.indicatorView = nil
                hud.textLabel.font = UIFont.systemFont(ofSize: 15.0)
                hud.textLabel.text = ("Email Anda Salah")
                hud.position = .center
            }
        }
        hud.dismiss(afterDelay: 3.0)
    }
    
    func passwordSalah(){
        let hud = JGProgressHUD(style: .dark)
        
        hud.show(in: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            UIView.animate(withDuration: 0.3) {
                hud.indicatorView = nil
                hud.textLabel.font = UIFont.systemFont(ofSize: 15.0)
                hud.textLabel.text = ("Password Salah")
                hud.position = .center
            }
        }
        hud.dismiss(afterDelay: 3.0)
    }
}
