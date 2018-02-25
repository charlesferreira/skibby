//
//  TabBarController.swift
//  Skibby
//
//  Created by Charles Ferreira on 25/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    @IBInspectable var initialIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = initialIndex
    }
    
}
