//
//  DirectionsViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/20/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit
import GoogleMaps

class DirectionsViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var getDirectionsMapView: GMSMapView!
    
    var location: CLLocationCoordinate2D!
    
    var directionsViewController = DirectionsViewController()
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDirectionsMapView.delegate = self
        
        // Set initial view to the bakery
        let camera = GMSCameraPosition.camera(withLatitude: 39.0934894, longitude: -94.5815152, zoom: 3.0)
        getDirectionsMapView.camera = camera
        
        //getDirectionsMapView.isTrafficEnabled = true
        
        // Create a marker for Ibis Bakery
        let ibisMarker = GMSMarker()
        ibisMarker.position = CLLocationCoordinate2D(latitude: 39.0934894, longitude: -94.5815152)
        ibisMarker.title = "Messenger Coffee Co. + Ibis Bakery"
        ibisMarker.snippet = "1624 Grand Boulevard, Kansas City, MO 64108"
        ibisMarker.map = getDirectionsMapView
        
        locationManager.delegate = self as! CLLocationManagerDelegate
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.requestLocation()
        
        
        
    }
    
    
    
    
    
}

extension DirectionsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
            getDirectionsMapView.isMyLocationEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        if let firstLocation = locations.first {
            print("Location: \(firstLocation)")
            
            directionsViewController.location = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}


