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
    static let storage = Storage()
    
    private init() {}
}

extension Constants {
    
    struct UserDefaults {
        let keyForUID         = "uid"
        let keyForAllMessages = "allMessages"
        let keyForOwnMessages = "ownMessages"
        let showNSFW          = "showNSFW"
        let hideOwnMessages   = "hideOwnMessages"
        let hideCollectedMessages = "hideCollectedMessages"
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
    
    struct Storage {
        func messageFullSizedImagePath(forKey key: String) -> String {
            return "messages/full-size/\(key).jpg"
        }
        func messageThumbnailImagePath(forKey key: String) -> String {
            return "messages/thumbnail/\(key).jpg"
        }
        
        let maxImageSize: CGSize = CGSize(width: 1024, height: 1024)
        let thumbnailSize: CGSize = CGSize(width: 128, height: 128)
    }
}
