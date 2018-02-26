//
//  TabBarController.swift
//  Skibby
//
//  Created by Charles Ferreira on 25/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

protocol TabBarControllerDelegate: AnyObject {
    func tabBar(_ tabBar: TabBarController, didUpdateMessagesBadge badgeValue: String?)
}

class TabBarController: UITabBarController {
    
    weak var customDelegate: TabBarControllerDelegate?
    
    @IBInspectable var initialIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = initialIndex
    }
    
    func notifyMessageCollected() {
        if let messagesItem = tabBar.items?.first {
            let count = UserManager.sharedManager().newCollectedMessages.count
            messagesItem.badgeValue = count > 0 ? count.description : nil
            customDelegate?.tabBar(self, didUpdateMessagesBadge: messagesItem.badgeValue)
        }
    }
    
}
