//
//  ShowMessage.swift
//  Skibby
//
//  Created by Charles Ferreira on 26/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class ShowMessageController: UIViewController {

    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var messageID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        MessagesManager.sharedManager().loadMessage(identifiedBy: messageID) { (message) in
            self.messageLabel.text = message.text
            let showNSFW = UserDefaults.standard.bool(forKey: Constants.userDefaults.showNSFW)
            if message.isNSFW && !showNSFW {
                return
            }
            
            FileStore.sharedManager().fullSizedImage(forKey: self.messageID) { (image, error) in
                guard let image = image else { return }
                self.backgroundView.image = image
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
}
