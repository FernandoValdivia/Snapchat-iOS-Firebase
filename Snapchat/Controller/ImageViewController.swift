//
//  ImageViewController.swift
//  Snapchat
//
//  Created by mbtec22 on 5/20/21.
//
import UIKit
import FirebaseStorage
import FirebaseDatabase

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
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true,completion: nil)
    }
    
    @IBAction func chooseContactTapped(_ sender: UIButton) {
        chooseContactButton.isEnabled = true
        let imageData = imageView.image!.pngData()!
        let storageReference = Storage.storage()
        let imageFolder = storageReference.reference().child("images")

        imageFolder.child("\(NSUUID().uuidString).jpg").putData(imageData, metadata: nil){metadata, error in
            if error == nil {
                imageFolder.downloadURL {url, error in
                    print("URL")
                    guard let url = url else {return}
                    print(url.absoluteString)
                    print(url.absoluteURL)
                    self.performSegue(withIdentifier: "chooseContactSegue", sender: url.absoluteString)
                }
                
            }
            else {
                print("Ocurrio un error: \(error)")
            }
            }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ChooseContactViewController
        siguienteVC.imageURL = sender as! String
        siguienteVC.descrip = descriptionTextField.text!
    }
}

    
    

