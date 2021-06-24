//
//  ViewSnapViewController.swift
//  Snapchat
//
//  Created by mbtec22 on 6/17/21.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ViewSnapViewController: UIViewController {
    @IBOutlet weak var descripTextField: UILabel!
    @IBOutlet weak var imageSnap: UIImageView!
    
    var snap = Snap()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descripTextField.text = snap.descrip
        imageSnap.sd_setImage(with: URL(string: snap.imageURL))
    }
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("snaps").child(snap.id).removeValue()
        
        Storage.storage().reference().child("images").child("\(snap.imageID).jpg").delete{ (error) in
            print("Se eliminó la imagen correctamente del Storage")
        }
    }
    
    @IBAction func backwardBarButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
