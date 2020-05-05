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

class NewPostViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate {
    
    var ref : DatabaseReference?
    var refst : StorageReference?
    var image : UIImage? = nil
    
    
    @IBOutlet weak var alamatTextField: UITextField!
    @IBOutlet weak var nohpTextField: UITextField!
    @IBOutlet weak var uploadGambar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        refst = Storage.storage().reference(forURL: "gs://jangandibuang-b031c.appspot.com")
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func simpan(_ sender: Any) {
        let userID = Auth.auth().currentUser?.uid
        
        let postObject = [
            "alamat": alamatTextField.text,
            "no handphone": nohpTextField.text,
            "timestamp": [".sv":"timestamp"]
        ] as [String:Any]

        ref?.child("Posts").child(userID!).childByAutoId().setValue(postObject, withCompletionBlock: { (error, in) in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                //error handle
            }
        })
    
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func pilihgambar(_ sender: Any) {
        showImagePickerControllerActionSheet()
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
