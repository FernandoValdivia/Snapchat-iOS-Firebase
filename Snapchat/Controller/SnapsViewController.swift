import UIKit
import FirebaseDatabase
import FirebaseAuth

class SnapsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var snaps : [Snap] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("snaps").observe(DataEventType.childAdded, with: {
            (snapshot) in
            let snap = Snap()
            snap.imageURL = (snapshot.value as! NSDictionary)["imageURL"] as! String
            snap.from = (snapshot.value as! NSDictionary)["from"] as! String
            snap.descrip = (snapshot.value as! NSDictionary)["descripcion"] as! String
            snap.id = snapshot.key
            snap.imageID = (snapshot.value as! NSDictionary)["imageID"] as! String
            self.snaps.append(snap)
            self.tableView.reloadData()
        })
        
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("snaps").observe(DataEventType.childRemoved, with: { (snapshot) in
            var iterator = 0
            for snap in self.snaps {
                if snap.id == snapshot.key {
                    self.snaps.remove(at: iterator)
                }
                iterator += 1
            }
            self.tableView.reloadData()
        })
    }
    
    func setUpTable() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}
extension SnapsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0 {
            return 1 //Una celda con el mensaje de NO SNAPS
        }
        else {
            return snaps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if snaps.count == 0 {
            cell.textLabel?.text = "Aún no tienes Snaps "
        }
        else {
            let snap = snaps[indexPath.row]
            cell.textLabel?.text = snap.from
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "viewSnapSegue", sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSnapSegue" {
            let siguienteVC = segue.destination as! ViewSnapViewController
            siguienteVC.snap = sender as! Snap
        }
    }
}
