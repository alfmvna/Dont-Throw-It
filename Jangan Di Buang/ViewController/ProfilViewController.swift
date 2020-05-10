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
import FirebaseStorage
import FirebaseDatabase
import JGProgressHUD

class ProfilViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //variables
    let storageRef = Storage.storage().reference(forURL: "gs://jangandibuang-b031c.appspot.com")
    let databaseRef = Database.database().reference(fromURL: "https://jangandibuang-b031c.firebaseio.com/")
    var image: UIImage? = nil
    var alertController: UIAlertController?

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var profilimage: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var contohTextField: UITextField!{
        didSet{
            contohTextField.setRightView(image: UIImage.init(named: "icons8-user-100")!)
            contohTextField.tintColor = .darkGray
        }
    }
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.setRightView(image: UIImage.init(named: "icons8-email-100")!)
            emailTextField.tintColor = .darkGray
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.setRightView(image: UIImage.init(named: "icons8-password-100")!)
            passwordTextField.tintColor = .darkGray
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewCorner.layer.cornerRadius = 15.00
        
        fetchdata()
        setupViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.contohTextField.becomeFirstResponder()
            self.emailTextField.becomeFirstResponder()
            self.passwordTextField.becomeFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    lazy var imagePickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .camera
        return controller
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    fileprivate func setupViews() {
        view.backgroundColor = .darkGray
        
        view.addSubview(imageView)
        view.addSubview(activityIndicator)

    }
    
    //action
    @IBAction func uploadimagesButton(_ sender: Any) {
        showImagePickerControllerActionSheet()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        logout()
    }
    
    
    func logout(){
        view.endEditing(true)
        alertController = UIAlertController(title: "Alert", message: "Apakah Anda Ingin Keluar ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Batal", style: .destructive) { (action) in
            print("Batal Di Pilih")
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            do {
                try Auth.auth().signOut()
            } catch _ {
                self.alertController = UIAlertController(title: "Alert", message: "Logout Gagal", preferredStyle: .alert)
                self.alertController?.addAction(cancelAction)
                self.present(self.alertController!, animated: true)
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "VC")
            self.present(signInVC, animated: true, completion: nil)
            
        }
        alertController?.addAction(cancelAction)
        alertController?.addAction(okAction)
        self.present(alertController!, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
                self.Keluar()
            }
        }
    }
    
    //fetch data
    func fetchdata() {
        if Auth.auth().currentUser?.uid != nil{
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            databaseRef.child("users").child("profile").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dict = snapshot.value as? [String: AnyObject] else {return}
                
                let user = CurrentUser(uid: uid, dictionary: dict)
                
                self.contohTextField.text! = user.namadepan
                self.emailTextField.text! = user.email
                
                self.profilimage.layer.cornerRadius = self.profilimage.bounds.height / 2
                self.profilimage.clipsToBounds = true
                
                if let profilImageURL = dict["PhotoURL"] as? String {
                    guard let url = URL(string: profilImageURL) else {return}
                    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        DispatchQueue.main.async {
                            self.profilimage.image = UIImage(data: data!)
                        }
                    }).resume()
                }

            }) { (error) in
                print("Error di Fetch Data")
            }
        }
    }

    //simpanfoto
    @IBAction func simpan(_ sender: Any) {
        view.endEditing(true)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let editedImage = self.image else {
            return
        }
        guard let imageData = editedImage.jpegData(compressionQuality: 0.4) else { return }
        
        alertController = UIAlertController(title: "Alert", message: "Apakah Anda Ingin Menyimpan ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Batal", style: .destructive) { (action) in
            print("Tekan Batal")
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let postObject = [
                "NamaDepan": self.contohTextField.text!,
                "UpdateTerbaru": [".sv":"timestamp"]
                ] as [String:Any]
            
            self.databaseRef.child("users").child("profile").child(uid).updateChildValues(postObject) { (error, database) in
                if error != nil {
                    print("Error UpdateChild.Users")
                }
            }
            
            let storageRef = Storage.storage().reference(forURL: "gs://jangandibuang-b031c.appspot.com")
            let storageProfileRef = storageRef.child("users").child("profile").child(uid)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            storageProfileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
                if error != nil {
                    print(error!)
                    return
                }
                storageProfileRef.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    if let urlText = url?.absoluteString{
                        self.databaseRef.child("users").child("profile").child(uid).updateChildValues(["PhotoURL" : urlText], withCompletionBlock: { (error, ref) in
                            if error != nil {
                                print(error!)
                                return
                            }
                        })
                    }
                })
            }
        }
        alertController?.addAction(cancelAction)
        alertController?.addAction(okAction)
        self.present(alertController!, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
                self.berhasilTersimpan()
            }
        }
        

    }
    
    func presentAlert(title: String, message: String) {
        activityIndicator.stopAnimating()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}

extension ProfilViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet(){
        let sheet = UIAlertController(title: "Pilih Gambar", message: "", preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Pilih Dari Galeri", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Ambil Dengan Kamera", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        sheet.addAction(photoLibraryAction)
        sheet.addAction(cameraAction)
        sheet.addAction(cancelAction)
        present(sheet, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = editedImage
            profilimage.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = originalImage
            profilimage.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}


extension ProfilViewController{
    
    func Keluar(){
        let hud = JGProgressHUD(style: .dark)
        
        hud.vibrancyEnabled = true
        hud.textLabel.text = "Keluar"
        hud.layoutMargins = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
    }
    
    func masukkanFoto(){
        let hud = JGProgressHUD(style: .dark)
        
        hud.show(in: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            UIView.animate(withDuration: 0.3) {
                hud.indicatorView = nil
                hud.textLabel.font = UIFont.systemFont(ofSize: 15.0)
                hud.textLabel.text = ("Masukkan Foto")
                hud.position = .center
            }
        }
        hud.dismiss(afterDelay: 3.0)
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
    
    func berhasilTersimpan() {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        hud.textLabel.text = "Loading.."
        hud.layoutMargins = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
        
        hud.show(in: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            UIView.animate(withDuration: 0.5) {
                hud.indicatorView = nil
                hud.textLabel.font = UIFont.systemFont(ofSize: 15.0)
                hud.textLabel.text = "Berhasil Tersimpan"
                hud.position = .center
            }
        }
        
        hud.dismiss(afterDelay: 3.0)
    }
}
