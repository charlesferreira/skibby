//
//  AppDelegate.swift
//  Skibby
//
//  Created by Charles Ferreira on 22/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var geoMailer = GeoMailer()
    var locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        signInAnonymously()
        setUpLocationManager()
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        return true
    }
    
    private func signInAnonymously() {
        Auth.auth().signInAnonymously { (user, error) in
            guard error == nil, let user = user else {
                fatalError(Errors.firebase.didFailToSignIn(with: error))
            }
            
            User.shared.id = user.uid
        }
    }
    
    private func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = Constants.location.desiredAccuracy
        locationManager.distanceFilter = Constants.location.distanceFilter
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        print("Pediu localização")
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Atualizou localização")
        
        guard let location = locations.first else { return }
        
        geoMailer.updateUserLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(Errors.location.didFail(with: error))
    }
}

