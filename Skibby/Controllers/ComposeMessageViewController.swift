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
    
    @IBOutlet weak var textView: UITextView!
    
    var location: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        guard let senderID = User.shared.id,
            let text = textView.text else { return }
        
        var message = Message(id: nil, senderID: senderID, text: text)
        message.save(at: location)
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
    }
}
