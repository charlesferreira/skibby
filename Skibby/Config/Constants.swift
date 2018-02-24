//
//  Constants.swift
//  Skibby
//
//  Created by Charles Ferreira on 22/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import MapKit

struct Constants {
    
    static let location = Location()
    static let geoFire = GeoFire()
    static let messages = Messages()
    
    private init() {}
}

extension Constants {
    
    struct Location {
        let desiredAccuracy: CLLocationAccuracy     = kCLLocationAccuracyNearestTenMeters
        let distanceFilter: CLLocationDistance      = 50  // in meters
        let initialZoomDistance: CLLocationDistance = 500 // in meters
    }
    
    struct GeoFire {
        let path: String            = "geofire"       //
        let visibleRadius: Double   = 0.6             // in kilometers
        let reachableRadius: Double = 0.05            // in kilometers
    }
    
    struct Messages {
        let allMessagesPath: String    = "messages"
        var userMessagesPath: String {
            guard let uid = User.shared.id else {
                fatalError(Errors.user.idNotSet)
            }
            return "users/\(uid)/messages"
        }
    }
}
