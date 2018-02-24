//
//  MapViewController.swift
//  Skibby
//
//  Created by Charles Ferreira on 23/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // suprime o popup "My Location" no mapa
        mapView.userLocation.title = ""
    }
    
    override func viewWillLayoutSubviews() {
        zoomToUserLocation()
    }
    
    private func zoomToUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let distance = Constants.location.initialZoomDistance
        let region = MKCoordinateRegionMakeWithDistance(coordinate, distance, distance)
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    }
    
}
