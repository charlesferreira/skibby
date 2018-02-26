//
//  MessageTableViewCell.swift
//  Skibby
//
//  Created by Charles Ferreira on 25/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateDiffLabel: UILabel!
    
    func setup(forMessage message: Message, date: Date) {
        // labels
        messageLabel.text = message.text
        dateDiffLabel.text = date.diffForHumans()
        
        // não lida
        let newMessages = UserManager.sharedManager().newCollectedMessages
        if newMessages.contains(message.id!) {
            contentView.backgroundColor = UIColor(hue: 0.55, saturation: 0.075, brightness: 1, alpha: 1)
        } else {
            contentView.backgroundColor = UIColor.white
        }
        
        // thumbnail
        guard !message.isNSFW || UserDefaults.standard.bool(forKey: Constants.userDefaults.showNSFW) else {
            self.thumbnail.image = #imageLiteral(resourceName: "message-thumbnail-example")
            return
        }
        
        thumbnail.layer.cornerRadius = thumbnail.frame.size.height / 2
        FileStore.sharedManager().thumbnail(forKey: message.id!) { (image, error) in
            if let image = image {
                self.thumbnail.image = image
            } else {
                self.thumbnail.image = #imageLiteral(resourceName: "message-thumbnail-example")
            }
        }
    }
}
