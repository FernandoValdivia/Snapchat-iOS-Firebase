//
//  ChooseContactViewController.swift
//  Snapchat
//
//  Created by mbtec22 on 5/20/21.
//

import UIKit
import FirebaseDatabase

class ChooseContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private let database = Database.database().reference()
    var contactos : [Contact] = []
    var imageURL = ""
    var descrip = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        database.child("users").observe(DataEventType.childAdded, with: {(snapshot) in
//            print(snapshot)
//            
//            let contacto = Contact()
//            contacto.email = (snapshot.value as! NSDictionary)["email"] as! String
//            contacto.uid = snapshot.key
//            self.contactos.append(contacto)
//            self.tableView.reloadData()
//        });
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
