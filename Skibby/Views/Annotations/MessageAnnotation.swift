//
//  MessageAnnotation.swift
//  Skibby
//
//  Created by Charles Ferreira on 25/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import MapKit

class MessageAnnotation: MKPointAnnotation {
    
    weak var colorView: MKMarkerAnnotationView? { didSet { updateColor() } }
    
    enum PinType {
        case ownAuthorship
        case collectible
        case collected
    }
    
    var type: PinType { didSet { updateColor() } }
    
    var color: UIColor {
        switch type {
        case .ownAuthorship: return UIColor(hue: 0.58, saturation: 1.0, brightness: 0.90, alpha: 1.0)
        case .collectible:   return UIColor(hue: 0.05, saturation: 1.0, brightness: 0.90, alpha: 1.0)
        case .collected:     return UIColor(hue: 0.05, saturation: 0.3, brightness: 0.90, alpha: 1.0)
        }
    }
    
    init(type: PinType) {
        self.type = type
        super.init()
    }
    
    func updateColor() {
        colorView?.markerTintColor = color
    }
    
}
