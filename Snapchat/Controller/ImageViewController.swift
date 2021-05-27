//
//  ImageViewController.swift
//  Snapchat
//
//  Created by mbtec22 on 5/20/21.
//

import UIKit
import FirebaseStorage

class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var chooseContactButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let url = info[UIImagePickerController.InfoKey.imageURL] as! URL
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
        uploadToCLoud(fileURL: url)
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true,completion: nil)
    }
    
    @IBAction func chooseContactTapped(_ sender: UIButton) {
        
    }
    
    func uploadToCLoud(fileURL: URL){
        let storage = Storage.storage()
        let data = Data()
        let storageRef = storage.reference()
        let localFile = fileURL
        let photoRef = storageRef.child("images/\(NSUUID().uuidString).jpg")
        let uploadTask = photoRef.putFile(from: localFile, metadata: nil) {
            (metadata, err) in
            print(err?.localizedDescription)
            return
        }
        print("Image Upload")
    }
}
