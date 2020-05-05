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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser?.uid == nil {
            logout()
        }
        setupProfil()
    }
    //action
    @IBAction func uploadimagesButton(_ sender: Any) {
        showImagePickerControllerActionSheet()
    }
    
    @IBAction func savechanges(_ sender: Any) {
        saveChanges()
    }
    
    @IBAction func LogoutTapped(_ sender: Any) {
        logout()
    }
    
    //func
    func logout(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "VC")
        present(loginViewController, animated: true, completion: nil)
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
            profilimage.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilimage.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func setupProfil(){

        profilimage.layer.cornerRadius = profilimage.frame.size.width/2
        profilimage.clipsToBounds = true
        let uid = Auth.auth().currentUser?.uid
        databaseRef.child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject]
            {
                self.profilnama.text = dict["NamaDepan"] as? String
                if let profilimageURL = dict["pic"] as? String
                {
                    let url = URL(string: profilimageURL)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil {
                            print(error)
                            return
                        }
                        DispatchQueue.main.async {
                            self.profilimage?.image = UIImage(data: data!)
                        }
                    }).resume()
                }
            }
        }}
    
    func saveChanges(){
 
    }
    
}
    
    

