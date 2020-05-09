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
            showError("Isi Kotak Yang Kosong")
            timerShowKosong()
            return ""
        }
        
        let cleanedPassword = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedEmail = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            showError("Password Wajib 6 Character, Huruf Besar, Angka Atau Simbol")
            timerShowKosong()
            return ""
        }
        
        if Utilities.isEmailValid(cleanedEmail) == false {
            showError("Email Anda Salah Format")
            timerShowKosong()
            return ""
        }
        return nil
    }

    @IBAction func daftarTapped(_ sender: Any) {
        self.view.endEditing(true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3.0)
        
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
                        self.showError("Email Tersedia")
                        self.timerShowKosong()
                        print(error)
                    } else if let provider = provider {
                        self.showError("Email Sudah Terdaftar")
                        self.timerShowKosong()
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
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {

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
