//
//  Message.swift
//  Skibby
//
//  Created by Charles Ferreira on 22/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import GeoFire
import Firebase
import CoreLocation

struct Message {
    
    var id: String?
    var senderID: String
    var text: String
    
    var dictionary: [String: Any?] {
        let values = [
            "senderID": senderID,
            "text": text
        ]
        return values
    }
    
    mutating func save(at location: CLLocation) {
        saveToFirebase()
        saveToUserMessages()
        saveToGeoFire(at: location)
    }
    
    mutating private func saveToFirebase() {
        let ref = Database.database().reference(withPath: Constants.messages.allMessagesPath)
        let newMessage = ref.childByAutoId()
        id = newMessage.key
        newMessage.setValue(dictionary)
    }
    
    private func saveToUserMessages() {
        guard let id = id else { return }
        
        let path = Constants.messages.userMessagesPath + "/\(id)"
        let ref = Database.database().reference(withPath: path)
        ref.setValue(true)
    }
    
    private func saveToGeoFire(at location: CLLocation) {
        guard let key = id else { return }
        
        let geoFireRef = Database.database().reference(withPath: Constants.geoFire.path)
        let geoFire = GeoFire(firebaseRef: geoFireRef)
        geoFire.setLocation(location, forKey: key)
    }
}