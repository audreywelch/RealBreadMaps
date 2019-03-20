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
    
    var bakeries = [BakeryIDS.a, .b, .c, .d, .e, .f, .g, .h, .i, .j, .k, .l, .m, .n, .o, .p, .q, .r, .s, .t, .u, .v, .w, .x, .y, .z, .aa, .bb, .cc, .dd, .ee, .ff, .gg, .hh, .ii, .jj, .kk]
    
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
        
        for eachBakeryID in bakeries {
            BakeryModelController.shared.searchForBakery(with: eachBakeryID.rawValue) { (error) in
                
                if BakeryModelController.shared.bakery != nil {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: BakeryModelController.shared.bakery?.geometry.location.lat ?? 0, longitude: BakeryModelController.shared.bakery?.geometry.location.lng ?? 0)
                    marker.title = "\(BakeryModelController.shared.bakery!.name)" ?? ""
                    marker.snippet = "\(BakeryModelController.shared.bakery!.formattedAddress)" ?? ""
                    marker.map = self.mapView
                } else {
                    
                }

            }
        }
        //BakeryModelController.shared.searchForBakery(with: "ChIJsyPVS2jwwIcRgxML7BXE7eQ") { (error) in
           
        //}
        
        //locationManager.delegate = self
        
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
//        locationManager.requestWhenInUseAuthorization()
//
//        locationManager.requestLocation()
        
        //mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)

    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if !didFindMyLocation {
////            //let myLocation: CLLocation = change![NSKeyValueChangeKey] as CLLocation
////            mapView.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 10.0)
////            mapView.settings.myLocationButton = true
////
////            didFindMyLocation = true
//        }
//    }

    
}

//extension BakeryMapViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.requestLocation()
//            mapView.isMyLocationEnabled = true
//        }
//    }
//}
