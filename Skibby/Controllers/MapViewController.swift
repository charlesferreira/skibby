//
//  MapViewController.swift
//  Skibby
//
//  Created by Charles Ferreira on 23/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit
import MapKit
import GeoFire

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var geoFence: GeoFence!
    private var annotations = [String: WeakReference<MKAnnotation>]()
    private var messages = MessagesManager.sharedManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.userLocation.title = ""
        
        UserManager.sharedManager().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpGeoFence()
        zoomToUserLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tearDownGeoFence()
    }
    
    private func setUpGeoFence() {
        geoFence = GeoFence(radius: Constants.geoFire.visibleRadius)
        geoFence.delegate = self
    }
    
    private func tearDownGeoFence() {
        geoFence = nil
    }
    
    private func zoomToUserLocation() {
        guard let coordinate = GeoManager.sharedManager().location?.coordinate else { return }
        let distance = Constants.location.initialZoomDistance
        let region = MKCoordinateRegionMakeWithDistance(coordinate, distance, distance)
        mapView.setRegion(region, animated: true)
    }
    
    private func createAnnotation(for message: Message, at location: CLLocation) {
        guard annotations[message.id!] == nil else { return }
        
        let type = annotationType(for: message)
        let annotation = MessageAnnotation(type: type)
        annotation.coordinate = location.coordinate
        mapView.addAnnotation(annotation)
        annotations[message.id!] = WeakReference(value: annotation)
    }
    
    private func removeAnnotation(forKey key: String) {
        guard let annotation = annotations[key]?.value else { return }
        mapView.removeAnnotation(annotation)
        annotations[key] = nil
    }
    
    private func annotationType(for message: Message) -> MessageAnnotation.PinType {
        let user = UserManager.sharedManager()
        if user.canCollect(message: message) {
            return .collectible
        }
        
        return user.uid == message.senderID ? .ownAuthorship : .collected
    }
}

extension MapViewController: GeoFenceDelegate {
    
    func geoFence(_ geoFence: GeoFence, didSetUpQuery query: GFCircleQuery) {
        query.observe(.keyEntered) { [weak self] (key, location) in
            self?.messages.loadMessage(identifiedBy: key) { [weak self] (message) in
                self?.createAnnotation(for: message, at: location)
            }
        }
        query.observe(.keyExited) { [weak self] (key, location) in
            self?.removeAnnotation(forKey: key)
        }
    }
}

extension MapViewController: UserManagerDelegate {
    
    func userManager(_ manager: UserManager, didCollectMessage message: Message) {
        guard let messageID = message.id,
            let annotation = annotations[messageID]?.value as? MessageAnnotation else { return }
        annotation.type = .collected
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MessageAnnotation else { return nil }
        
        let identifier = "MessageAnnotation"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            view = dequeuedView
            view.annotation = annotation
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotation.colorView = view
        
        return view
    }
}







