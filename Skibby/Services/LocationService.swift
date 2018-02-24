//
//  GeoMailer.swift
//  Skibby
//
//  Created by Charles Ferreira on 24/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import CoreLocation
import GeoFire
import Firebase

class GeoMailer {
    
    private var visibleMessages: GFCircleQuery?
    private var reachableMessages: GFCircleQuery?
    
    func updateUserLocation(_ location: CLLocation) {
        updateVisibleMessages(at: location)
        updateReachableMessages(at: location)
    }

    private func updateVisibleMessages(at userLocation: CLLocation) {
        guard let query = visibleMessages else {
            initVisibleMessages(at: userLocation)
            return
        }
        
        query.center = userLocation
    }
    
    private func updateReachableMessages(at userLocation: CLLocation) {
        guard let query = reachableMessages else {
            initReachableMessages(at: userLocation)
            return
        }
        
        query.center = userLocation
    }
    
    private func initVisibleMessages(at userLocation: CLLocation) {
        // cria a query das mensagens visíveis
        let radius = Constants.geoFire.visibleRadius
        visibleMessages = createGeoQuery(at: userLocation, withRadius: radius)
        
        // observa mensagens que aparecem
        visibleMessages!.observe(.keyEntered) { [weak self] (key, location) in
            self?.messageDidAppear(messageID: key, location: location)
        }
        
        // observa mensagens que somem
        visibleMessages!.observe(.keyExited) { [weak self] (key, location) in
            self?.messageDidDisappear(messageID: key, location: location)
        }
    }
    
    private func initReachableMessages(at userLocation: CLLocation) {
        // cria a query das mensagens ao alcance de coleta
        let radius = Constants.geoFire.visibleRadius
        reachableMessages = createGeoQuery(at: userLocation, withRadius: radius)
        
        // observa mensagens a serem coletadas
        reachableMessages!.observe(.keyEntered) { [weak self] (key, location) in
            self?.collectMessage(messageID: key, location: location)
        }
    }
    
    private func createGeoQuery(at location: CLLocation, withRadius radius: Double) -> GFCircleQuery {
        let geoFireRef = Database.database().reference(withPath: Constants.geoFire.path)
        let geoFire = GeoFire(firebaseRef: geoFireRef)
        
        return geoFire.query(at: location, withRadius: radius)
    }
    
    private func messageDidAppear(messageID: String, location: CLLocation) {
        print("Mensagem apareceu: ID \(messageID)")
    }
    
    private func messageDidDisappear(messageID: String, location: CLLocation) {
        print("Mensagem desapareceu: ID \(messageID)")
    }
    
    private func collectMessage(messageID: String, location: CLLocation) {
        print("Coletar mensagem: ID \(messageID)")
    }
}
