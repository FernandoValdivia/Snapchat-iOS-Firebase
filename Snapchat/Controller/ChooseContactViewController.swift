//
//  ChooseContactViewController.swift
//  Snapchat
//
//  Created by mbtec22 on 5/20/21.
//
import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChooseContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private let database = Database.database().reference()
    private let authuser = Auth.auth().currentUser
    var contactos : [Contact] = []
    var imageURL = ""
    var descrip = ""
    var imageID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        database.child("users").observe(DataEventType.childAdded, with: {(snapshot) in
            print(snapshot)
            
            let contacto = Contact()
            contacto.email = (snapshot.value as! NSDictionary)["email"] as! String
            contacto.uid = snapshot.key
            self.contactos.append(contacto)
            self.tableView.reloadData()
        });
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contacto = contactos[indexPath.row]
        let snap = [
            "from": authuser!.email!,
            "descripcion":descrip,
            "imagenURL":imageURL,
            "imageID":imageID
        ]
        database.child("users").child(contacto.uid).child("snaps").childByAutoId().setValue(snap)
        navigationController?.popToRootViewController(animated: true)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let contacto = contactos[indexPath.row]
        cell.textLabel?.text = contacto.email
        return cell
    }

}
