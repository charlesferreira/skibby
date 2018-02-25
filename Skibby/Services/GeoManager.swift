//
//  GeoManager.swift
//  Skibby
//
//  Created by Charles Ferreira on 24/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import CoreLocation

@objc protocol GeoManagerObserver: AnyObject {
    func geoManager(_ geoManager: GeoManager, didUpdateLocation location: CLLocation)
}

class GeoManager: NSObject {
    
    static func sharedManager() -> GeoManager {
        struct Static { static let instance = GeoManager() }
        return Static.instance
    }
    
    private var locationManager = CLLocationManager()
    private var observers = [WeakReference<GeoManagerObserver>]()
    
    var location: CLLocation? {
        return locationManager.location
    }
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = Constants.location.desiredAccuracy
        locationManager.distanceFilter = Constants.location.distanceFilter
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func addObserver(_ observer: GeoManagerObserver) {
        let ref = WeakReference(value: observer)
        observers.append(ref)
    }
    
    func removeObserver(_ observer: GeoManagerObserver) {
        observers = observers.filter { $0.value != nil }
    }
}

extension GeoManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        observers.forEach { $0.value?.geoManager(self, didUpdateLocation: location) }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(Errors.location.didFail(with: error))
    }
}
