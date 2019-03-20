//
//  BreadMapViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/18/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit
import GoogleMaps

class BakeryMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    // Use a CLLocation manager to show the user's location
    var locationManager = CLLocationManager()
    
    var didFindMyLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial view to the United States
        let camera = GMSCameraPosition.camera(withLatitude: 39.0934894, longitude: -94.5815152, zoom: 3.0)
        mapView.camera = camera
        
        // Creaet a marker for Ibis Bakery
        let ibisMarker = GMSMarker()
        ibisMarker.position = CLLocationCoordinate2D(latitude: 39.0934894, longitude: -94.5815152)
        ibisMarker.title = "Ibis Bakery"
        ibisMarker.snippet = "Kansas City, Missouri"
        ibisMarker.map = mapView
        
        //locationManager.delegate = self
        
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
//        locationManager.requestWhenInUseAuthorization()
//
//        locationManager.requestLocation()
        
        //mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !didFindMyLocation {
//            //let myLocation: CLLocation = change![NSKeyValueChangeKey] as CLLocation
//            mapView.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 10.0)
//            mapView.settings.myLocationButton = true
//
//            didFindMyLocation = true
        }
    }
    
    
}

//extension BakeryMapViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.requestLocation()
//            mapView.isMyLocationEnabled = true
//        }
//    }
//}
