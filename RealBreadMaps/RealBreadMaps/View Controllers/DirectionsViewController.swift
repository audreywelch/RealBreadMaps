//
//  DirectionsViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/20/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit
import GoogleMaps

class DirectionsViewController: UIViewController {
    
    @IBOutlet weak var getDirectionsMapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }
    
    
    
    
}


