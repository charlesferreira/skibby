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
        messageLabel.text = message.text
        
        thumbnail.layer.cornerRadius = thumbnail.frame.size.height / 2
        dateDiffLabel.text = date.diffForHumans()
        
        FileStore.sharedManager().thumbnail(forKey: message.id!) { (image, error) in
            if let image = image {
                self.thumbnail.image = image
            } else {
                self.thumbnail.image = #imageLiteral(resourceName: "message-thumbnail-example")
            }
        }
    }
}
