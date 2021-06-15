//
//  SigninViewController.swift
//  Snapchat
//
//  Created by mbtec22 on 5/14/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class SignupViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var password1TextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    
    private let database = Database.database().reference()
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func siginButton(_ sender: Any) {
        let username = usernameTextField.text!
        let user = userTextField.text!
        let pass1 = password1TextField.text!
        let pass2 = password2TextField.text!

        //Si el usuario o alguna de las contraseñas están vacías se muestra un alert
        if username.isEmpty || user.isEmpty || pass1.isEmpty || pass2.isEmpty {
            let alert = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(alertAction)
            self.DisplayAlert(titleD:"¡Hey!",messageD:"Please, Complete All")
            self.present(alert, animated: true, completion: nil)
        }else{
            if pass1 != pass2 {
                
                self.DisplayAlert(titleD:"¡Attention!",messageD:"Passwords are not similar, try again")
                
            } else {
                if pass1.count >= 7 {
                    //Si la contraseña es mayor a 7 caracteres se registra
                    Auth.auth().createUser(withEmail: user, password: pass1) {
                        (responseUser, error) in
                        
                        if error == nil {
                        
                            let usermodel = User(username: "\(username)", user: "\(user)")
                            let authuser = Auth.auth().currentUser
                            //Registrar usuario y nombre en la base de datos
                            //RealtimeDatabase
                            let object : [String: Any] = [
                                "username": "\(username)",
                                "email": "\(user)"
                            ]
                            
                            print(object)
                            self.database.child("users/\(authuser!.uid)/username").setValue(username)
                            
                            self.database.child("users").child(authuser!.uid).setValue(object)
                            
                            //FirestoreDatabase
                            self.db.collection("users").document(authuser!.uid).setData([
                                "username":username,
                                "user":user
                            ])
                            print("Todo buenardo, usuario creado exitosamente gg")
                            
                            //Navegar hacia Home
                            self.performSegue(withIdentifier: "signupSegue", sender: nil)
                            
                        }else {
                         
                            self.DisplayAlert(titleD:"¡Oops!",messageD:"User or Password incorrect")
                            print("Todo malardo")
                            
                        }
                    }
                } else {
                    //Caso contrario se muestra un alert
                    self.DisplayAlert(titleD:"¡Hey!",messageD:"Passwords must be greater than 7 characters")
                }
            }
        }
    }
    
    //Funcion para mostrar el alert
    func DisplayAlert(titleD:String, messageD:String){
        let alert = UIAlertController(title: titleD, message: messageD, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}
