//
//  GeoFence.swift
//  Skibby
//
//  Created by Charles Ferreira on 24/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Firebase
import GeoFire

protocol GeoFenceDelegate: AnyObject {
    func geoFence(_ geoFence: GeoFence, didSetUpQuery query: GFCircleQuery)
}

class GeoFence {
    
    weak var delegate: GeoFenceDelegate?
    
    private var query: GFCircleQuery?
    
    var radius: Double {
        didSet {
            query?.radius = radius
        }
    }
    
    var location: CLLocation! {
        didSet {
            guard let query = query else {
                setUpQuery()
                return
            }
            
            query.center = location
        }
    }
    
    init(radius: Double) {
        self.radius = radius
        GeoManager.sharedManager().addObserver(self)
    }
    
    deinit {
        query?.removeAllObservers()
        GeoManager.sharedManager().removeObserver(self)
    }
    
    private func setUpQuery() {
        let geoFireRef = Database.database().reference(withPath: Constants.geoFire.path)
        let geoFire = GeoFire(firebaseRef: geoFireRef)
        
        query = geoFire.query(at: location, withRadius: radius)
        delegate?.geoFence(self, didSetUpQuery: query!)
    }
}

extension GeoFence: GeoManagerObserver {
    
    func geoManager(_ geoManager: GeoManager, didUpdateLocation location: CLLocation) {
        self.location = location
    }
}
