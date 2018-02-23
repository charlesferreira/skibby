//
//  Constants.swift
//  Skibby
//
//  Created by Charles Ferreira on 22/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import MapKit

struct Constants {
    
    static let location = Location(
        distanceFilter: 100
    )
    
    static let geoFire = GeoFire(
        path: "geofire"
    )
    
    private init() {}
}

extension Constants {
    struct Location {
        let distanceFilter: CLLocationDistance
    }
}

extension Constants {
    struct GeoFire {
        let path: String
    }
}
