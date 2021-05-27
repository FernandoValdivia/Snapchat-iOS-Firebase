//
//  LogInViewController.swift
//  Snapchat
//
//  Created by mbtec22 on 5/14/21.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userTextField.text! = "luis@gmail.com"
        passwordTextField.text! = "luis123"
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        let user = userTextField.text!
        let password = passwordTextField.text!
        //Si alguno de los campos están vacíos, mostrar un alert
        if user.isEmpty || password.isEmpty {
            
            self.DisplayAlert(titleD: "¡Hey!",messageD: "Please, Complete All")
            
        }else{
            //Caso contrario se inicia sesión
            Auth.auth().signIn(withEmail: user, password: password) { (responseUser, error) in
                if error == nil {
                    
                    print("Todo buenardo")
                    
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    
                }else {
                    
                    self.DisplayAlert(titleD: "¡Oops!",messageD: "User or Password incorrect")
                    print("Todo malardo")
                    
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
