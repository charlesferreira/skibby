//
//  Constants.swift
//  Skibby
//
//  Created by Charles Ferreira on 22/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import MapKit

struct Constants {
    
    static let userDefaults = UserDefaults()
    static let location = Location()
    static let geoFire = GeoFire()
    static let messages = Messages()
    
    private init() {}
}

extension Constants {
    
    struct UserDefaults {
        let keyForUID      = "uid"
        let keyForMessages = "messages"
    }
    
    struct Location {
//        let desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyNearestTenMeters
        let desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest
        let distanceFilter: CLLocationDistance = 5 // in meters
        let initialZoomDistance: CLLocationDistance = 500 // in meters
    }
    
    struct GeoFire {
        let path: String = "geofire"
        let visibleRadius: Double = 0.2 // in kilometers
        let collectRadius: Double = 0.025 // in kilometers
    }
    
    struct Messages {
        let allMessagesPath: String = "messages"
        var userMessagesPath: String {
            guard let uid = UserManager.sharedManager().uid else {
                fatalError(Errors.user.idNotSet)
            }
            return "users/\(uid)/messages"
        }
    }
}
