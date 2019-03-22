//
//  BreadMapViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/18/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit
import GoogleMaps

class BakeryMapViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let bakeryDetailViewController = BakeryDetailViewController()
    
    // Use a CLLocation manager to show the user's location
    var locationManager = CLLocationManager()
    
    var didFindMyLocation = false
    
    var bakeries = [BakeryIDS.a, .b, .c, .d, .e, .f, .g, .h, .i, .j, .k, .l, .m, .n, .o, .p, .q, .r, .s, .t, .u, .v, .w, .x, .y, .z, .aa, .bb, .cc, .dd, .ee, .ff, .gg, .hh, .ii, .jj, .kk]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Set initial view to the United States
        let camera = GMSCameraPosition.camera(withLatitude: 39.0934894, longitude: -94.5815152, zoom: 3.0)
        mapView.camera = camera
        
        // Create a marker for Ibis Bakery
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
                    marker.icon = GMSMarker.markerImage(with: .ibisRed)
                    marker.title = "\(BakeryModelController.shared.bakery!.name)" ?? ""
                    marker.snippet = "\(BakeryModelController.shared.bakery!.formattedAddress)" ?? ""
                    marker.map = self.mapView
                    
                }
            }
        }
    }
    

    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        //marker.position

        //bakeryDetailViewController.bakery =
        
        BakeryModelController.shared.currentBakeryName = marker.title
        
        performSegue(withIdentifier: "showDetailViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = segue.destination as? BakeryDetailViewController else { return }
        
        
    }
    
}
