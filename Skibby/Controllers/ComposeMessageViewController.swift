//
//  ComposeMessageViewController.swift
//  Skibby
//
//  Created by Charles Ferreira on 22/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit
import CoreLocation

class ComposeMessageViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    var location: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        guard let senderID = UserManager.sharedManager().uid,
            let text = textField.text else { return }
        
        var message = Message(id: nil, senderID: senderID, text: text)
        message.save(at: location)
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
    }
}
