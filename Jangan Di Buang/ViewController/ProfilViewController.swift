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
import FirebaseFirestore

struct MyKeys {
    static let imagesFolder = "imagesFolder"
    static let imagesCollection = "imagesCollection"
    static let uid = "uid"
    static let imageUrl = "imageUrl"
}

class ProfilViewController: UIViewController {
    
    //variables
    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference()
    var image: UIImage? = nil
    
    //outlets
    @IBOutlet weak var profilimage: UIImageView!
    @IBOutlet weak var profilnama: UILabel!
    @IBOutlet weak var profilemail: UILabel!
    @IBOutlet weak var profilpassword: UILabel!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
        checkIfUserLoggedIn()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(activityIndicator)

    }
    
    //action
    @IBAction func uploadimagesButton(_ sender: Any) {
        showImagePickerControllerActionSheet()
    }
    
    
    @IBAction func simpan(_ sender: Any) {
        guard let userProfile = UserServices.currentUserProfile else {return}
        
        guard let editedImage = self.image else {
            print("Avatar is nil")
            return
        }
        guard let imageData = editedImage.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        let storageRef = Storage.storage().reference(forURL: "gs://jangandibuang-b031c.appspot.com")
        
        let uid = Auth.auth().currentUser?.uid
        let storageProfileRef = storageRef.child("profile").child(uid!)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
        }
    }
    
    
    @IBAction func LogoutTapped(_ sender: Any) {
        logout()
    }
    
    func checkIfUserLoggedIn() {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
            let photoURL = user.photoURL
        }
    }
    
    
    //func
    func logout(){
        let viewController = ViewController()
        present(viewController, animated: true, completion: nil)
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
