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
import FirebaseDatabase
import FirebaseStorage
import JGProgressHUD

class SignUpViewController: UIViewController {
    
    var ref : DatabaseReference!
    
    @IBOutlet weak var namadepanText: UITextField!{
        didSet{
            namadepanText.setRightView(image: UIImage.init(named: "icons8-user-100")!)
            namadepanText.tintColor = .darkGray
        }
    }
    @IBOutlet weak var namabelakangText: UITextField!{
        didSet{
            namabelakangText.setRightView(image: UIImage.init(named: "icons8-user-100")!)
            namabelakangText.tintColor = .darkGray
        }
    }
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
    
    @IBOutlet weak var daftarButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var viewDaftar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        daftarButton.layer.cornerRadius = 15.0
        emailText.layer.cornerRadius = 15.0
        viewDaftar.layer.cornerRadius = 15.00
        
    }

    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.namadepanText.becomeFirstResponder()
            self.namabelakangText.becomeFirstResponder()
            self.emailText.becomeFirstResponder()
            self.passwordText.becomeFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func validateFields() -> String? {
        
        if namadepanText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            namabelakangText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.silahkanisi()
            return ""
        }
        
        let cleanedPassword = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedEmail = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            self.passwordSalah()
            return ""
        }
        
        if Utilities.isEmailValid(cleanedEmail) == false {
            self.emailSalah()
            return ""
        }
        return nil
    }

    @IBAction func daftarTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        // Validasi
        let error = validateFields()
        
        if error != nil {
        
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
                Auth.auth().fetchSignInMethods(forEmail: self.emailText.text!, completion: { (provider, error) in
                    if let error = error {
                        self.emailAda()
                        print(error)
                    } else if let provider = provider {
                        self.emailGada()
                        print(provider)
                    }
                })
            } else {
                self.ref = Database.database().reference(fromURL: "https://jangandibuang-b031c.firebaseio.com/")
                
                guard let uid = Auth.auth().currentUser?.uid else {return}
                
                self.ref.child("users").child("profile").child(uid).setValue(["NamaDepan":namadepan, "NamaBelakang":namabelakang, "Email":email, "Password":password, "PhotoURL":"", "uid": result!.user.uid ])
                
                self.transitionToHome()
                }
            }
        }
    }
    
    
    func transitionToHome() {

        let myTabbar = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.myTabbar) as! UITabBarController
        
        self.view.window?.rootViewController = myTabbar
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func kembali(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension UITextField {
    func setRightView(image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 0, y: 15, width: 25, height: 25)) // set your Own size
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 45))
        iconContainerView.addSubview(iconView)
        rightView = iconContainerView
        rightViewMode = .always
        self.tintColor = .lightGray
    }
}

extension SignUpViewController{
    
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
    
    func emailAda(){
        let hud = JGProgressHUD(style: .dark)
        
        hud.show(in: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            UIView.animate(withDuration: 0.3) {
                hud.indicatorView = nil
                hud.textLabel.font = UIFont.systemFont(ofSize: 15.0)
                hud.textLabel.text = ("Email Tersedia")
                hud.position = .center
            }
        }
        hud.dismiss(afterDelay: 1.5)
    }
    
    func emailGada(){
        let hud = JGProgressHUD(style: .dark)
        
        hud.show(in: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            UIView.animate(withDuration: 0.3) {
                hud.indicatorView = nil
                hud.textLabel.font = UIFont.systemFont(ofSize: 15.0)
                hud.textLabel.text = ("Email Tidak Tersedia")
                hud.position = .center
            }
        }
        hud.dismiss(afterDelay: 1.5)
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
    
    func passwordSalahFormat(){
        let hud = JGProgressHUD(style: .dark)
        
        hud.show(in: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            UIView.animate(withDuration: 0.3) {
                hud.indicatorView = nil
                hud.textLabel.font = UIFont.systemFont(ofSize: 15.0)
                hud.textLabel.text = ("Password Wajib 8 Character, 1 Huruf Besar dan Angka")
                hud.position = .center
            }
        }
        hud.dismiss(afterDelay: 1.5)
    }
}
