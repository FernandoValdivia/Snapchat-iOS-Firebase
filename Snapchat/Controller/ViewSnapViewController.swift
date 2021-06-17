//
//  ViewSnapViewController.swift
//  Snapchat
//
//  Created by mbtec22 on 6/17/21.
//

import UIKit

class ViewSnapViewController: UIViewController {
    @IBOutlet weak var descripTextField: UILabel!
    @IBOutlet weak var imageSnap: UIImageView!
    var snap = Snap()
    override func viewDidLoad() {
        super.viewDidLoad()

        descripTextField.text = snap.descrip
    }
    


}
