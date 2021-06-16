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
        //Subir imagen
        uploadToCLoud(fileURL: url)
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true,completion: nil)
    }
    
    @IBAction func chooseContactTapped(_ sender: UIButton) {
        chooseContactButton.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ChooseContactViewController
        siguienteVC.imageURL = sender as! String // Sale nulo el sender
        siguienteVC.descrip = descriptionTextField.text!
    }
    
    func uploadToCLoud(fileURL: URL){
        
        let imagenesFolder = Storage.storage().reference().child("images")
        let imagenData = imageView.image!.pngData()! as NSData
        
        imagenesFolder.child("\(NSUUID().uuidString).jpg").putFile(from: fileURL, metadata: nil, completion: {(metadata, error) in
            print("intentando subir la imagen...")
            self.chooseContactButton.isEnabled = false
            if error != nil {
                print("Ocurrió un error:\(error)")
            } else {
                print("Imagen subida")
                self.chooseContactButton.isEnabled = true
                self.performSegue(withIdentifier: "chooseContactSegue", sender: metadata?.storageReference?.downloadURL(completion:{(fileURL, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                        return
                    }
                    let downloadURL = fileURL?.absoluteString
                }))
            }
        })
    }
}
