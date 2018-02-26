//
//  AppDelegate.swift
//  Skibby
//
//  Created by Charles Ferreira on 22/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit
import GeoFire
import Firebase
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var geoFence: GeoFence!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        UserManager.sharedManager().logIn()
        setUpGeoFence()
        
        return true
    }
    
    private func setUpGeoFence() {
        geoFence = GeoFence(radius: Constants.geoFire.collectRadius)
        geoFence.delegate = self
    }
}

extension AppDelegate: GeoFenceDelegate {
    
    func geoFence(_ geoFence: GeoFence, didSetUpQuery query: GFCircleQuery) {
        query.observe(.keyEntered) { (key, _) in
            let manager = MessagesManager.sharedManager()
            manager.loadMessage(identifiedBy: key, completion: { [weak self] (message) in
                UserManager.sharedManager().collect(message)
                if let controller = self?.window?.rootViewController as? TabBarController {
                    controller.notifyMessageCollected()
                }
            })
        }
    }
}



