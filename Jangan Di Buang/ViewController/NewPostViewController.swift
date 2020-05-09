//
//  NewPostViewController.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 05/05/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import JGProgressHUD

class NewPostViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var ref : DatabaseReference?
    var refst : StorageReference?
    let storageRef = Storage.storage().reference(forURL: "gs://jangandibuang-b031c.appspot.com")
    let databaseRef = Database.database().reference(fromURL: "https://jangandibuang-b031c.firebaseio.com/")
    var image : UIImage? = nil
    var alertController: UIAlertController?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var alamatTextField: UITextField!{
        didSet {
            alamatTextField.setRightView(image: UIImage.init(named: "icons8-address-128")!)
            alamatTextField.tintColor = .darkGray
        }
    }
    @IBOutlet weak var nohpTextField: UITextField!{
        didSet {
            nohpTextField.setRightView(image: UIImage.init(named: "icons8-call-160")!)
            nohpTextField.tintColor = .darkGray
        }
    }
    @IBOutlet weak var uploadGambar: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!

    func validateField() -> String? {
        if alamatTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            nohpTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            timerShowKosong()
            return "Isi Kotak Yang Kosong"
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(fromURL: "https://jangandibuang-b031c.firebaseio.com/")
        refst = Storage.storage().reference(forURL: "gs://jangandibuang-b031c.appspot.com")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.alamatTextField.becomeFirstResponder()
            self.nohpTextField.becomeFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func simpan(_ sender: Any) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let postRef = Database.database().reference().child("posts").child("profile").child(uid)
        guard let key = postRef.childByAutoId().key else {return}
        
        guard let editedImage = self.image else {
            self.errorLabel.text = "Masukkan Foto"
            self.timerShowKosong()
            return
        }
        
        guard let imageData = editedImage.jpegData(compressionQuality: 0.4) else { return }
        
        alertController = UIAlertController(title: "Alert", message: "Apakah Anda Ingin Memposting ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Batal", style: .cancel) { (action) in
            print("Tekan Batal")
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
        
            let postObject = [
                "alamat": self.alamatTextField.text!,
                "no handphone": self.nohpTextField.text!,
                "timestamp": [".sv":"timestamp"]
                ] as [String:Any]
            
            self.databaseRef.child("posts").child("profile").child(uid).child(key).setValue(postObject) { (error, database) in
                if error != nil {
                    print(error!)
                }
            }
            
            let storageRef = Storage.storage().reference(forURL: "gs://jangandibuang-b031c.appspot.com")
            let storageProfileRef = storageRef.child("users").child("posts").child(uid)
            
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
                        self.databaseRef.child("users").child("profile").child(uid).child(key).updateChildValues(["PhotoURL" : urlText], withCompletionBlock: { (error, ref) in
                            if error != nil {
                                print(error!)
                                return
                            }
                        })
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                });  self.dismiss(animated: true, completion: nil)
            }
        }
    
        self.alertController?.addAction(cancelAction)
        self.alertController?.addAction(okAction)
        self.present(self.alertController!, animated: true)
        
        self.alamatTextField.text?.removeAll()
        self.nohpTextField.text?.removeAll()
        
        self.present(alertController!, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
                self.showHUDWithTransform()
                self.view.endEditing(true)
            }
        }
        
    }
        
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func pilihgambar(_ sender: Any) {
        showImagePickerControllerActionSheet()
    }
    
    func timerShowKosong(){
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
            self.errorLabel.text = ""
        }
    }
    
    func showHUDWithTransform() {
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

extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            uploadGambar.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = originalImage
            uploadGambar.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
}

