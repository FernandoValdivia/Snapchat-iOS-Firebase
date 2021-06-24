//
//  HomeViewController.swift
//  Snapchat
//
//  Created by mbtec22 on 5/14/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class HomeViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    private let ref = Database.database().reference()
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFirestore()
        usernameField.isEnabled = false
        emailField.isEnabled = false
        usernameField.backgroundColor = #colorLiteral(red: 0.8981244789, green: 0.8981244789, blue: 0.8981244789, alpha: 1)
        emailField.backgroundColor = #colorLiteral(red: 0.9003623188, green: 0.9003623188, blue: 0.9003623188, alpha: 1)
        //validateUser()
        
    }
    
    //Obtener datos de Firestore
    func getDataFirestore(){
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument {
            (documentSnapshot, error) in
            
            if let document = documentSnapshot, error == nil {
                if let user = document.get("user") as? String {
                    self.emailField.text = user
                }
                if let username = document.get("username") as? String {
                    self.usernameField.text = username
                }
            }
        }
    }
    
    //Validar sesión de usuario
    func validateUser() {
            if Auth.auth().currentUser != nil {
                let storyboard: UIStoryboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
                let homeViewController = storyboard.instantiateViewController(withIdentifier: "MainHome") as! HomeViewController
                homeViewController.modalPresentationStyle = .fullScreen
                let navigationController = UINavigationController(rootViewController: homeViewController)
                navigationController.isToolbarHidden = false
                navigationController.modalPresentationStyle = .fullScreen
                //navigationController.modalTransitionStyle = .flipHorizontal
                
                self.present(navigationController, animated: true)
            }
        }
    
    //Cerrar sesión
    @IBAction func closeSessionButton(_ sender: UIBarButtonItem) {
        self.DisplayAlert(titleD: "Close Session", messageD: "Are You Sure?")
    }
    
    //Permitir editar los textFields
    @IBAction func editTapped(_ sender: UIButton) {
        usernameField.isEnabled = true
        usernameField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    //Guardar cambios
    @IBAction func saveChangesTapped(_ sender: UIButton) {
        //Actualizar datos
        self.db.collection("users").document(Auth.auth().currentUser!.uid).setData([
            "username":"\(usernameField.text!)",
            "user":"\(Auth.auth().currentUser!.email!)"
        ])
        
        let object : [String: Any] = [
            "username": "\(usernameField.text!)" as NSObject,
            "email": "\(Auth.auth().currentUser!.email!)" as NSObject
        ]
        self.ref.child("users").child("user-\(Auth.auth().currentUser!.uid)").setValue(object)
        
        self.DisplayAlertConfirm(titleD: "Saved Changes", messageD: "Saved Changes on Firestore")
        
        usernameField.isEnabled = false
        usernameField.backgroundColor = #colorLiteral(red: 0.9017476673, green: 0.9017476673, blue: 0.9017476673, alpha: 1)
        
        //Recargar datos
        getDataFirestore()
    }
    
    //Funcion para mostrar el alert de signout
    func DisplayAlert(titleD:String, messageD:String){
        let alert = UIAlertController(title: titleD, message: messageD, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "signoutSegue", sender: true)
                print("Close Session")
            } catch {
                print("Error Close Session")
            }
        })
        let alertAction2 = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(alertAction2)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Funcion de alert simple
    func DisplayAlertConfirm(titleD:String, messageD:String){
        let alert = UIAlertController(title: titleD, message: messageD, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}
