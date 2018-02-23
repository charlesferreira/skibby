//
//  TabBarController.swift
//  Skibby
//
//  Created by Charles Ferreira on 22/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit
import MapKit
import GeoFire
import Firebase

class TabBarController: UITabBarController {
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var geoFire: GeoFire!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        setupGeoFire()
        print("OOO")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.requestLocation()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = Constants.location.distanceFilter
        locationManager.requestAlwaysAuthorization()
    }
    
    func setupGeoFire() {
        let geoFireRef = Database.database().reference(withPath: Constants.geoFire.path)
        geoFire = GeoFire(firebaseRef: geoFireRef)
    }
}

extension TabBarController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(Errors.location.didFail(with: error))
    }
}




