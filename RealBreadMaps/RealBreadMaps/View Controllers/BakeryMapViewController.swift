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
    
    var bakeryIDs = [BakeryIDS.a, .b, .c, .d, .e, .f, .g, .h, .i, .j, .k, .l, .m, .n, .o, .p, .q, .r, .s, .t, .u, .v, .w, .x, .y, .z, .aa, .bb, .cc, .dd, .ee, .ff, .gg, .hh, .ii, .jj, .kk, .ll]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Set the map style by passing the URL of the local file
        do {
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        // Set initial view to the United States
        let camera = GMSCameraPosition.camera(withLatitude: 39.0934894, longitude: -94.5815152, zoom: 3.0)
        mapView.camera = camera
        
        for eachBakery in BakeryModelController.shared.bakeries {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: eachBakery.geometry.location.lat ?? 0, longitude: eachBakery.geometry.location.lng ?? 0)
            marker.icon = GMSMarker.markerImage(with: .roseRed)
            marker.title = "\(eachBakery.name)"
            marker.snippet = "\(eachBakery.formattedAddress)"
            marker.map = self.mapView
        }
        
//        for eachBakeryID in bakeryIDs {
//
//            BakeryModelController.shared.searchForBakery(with: eachBakeryID.rawValue) { (error) in
//
//                if BakeryModelController.shared.bakery != nil {
//
//                    DispatchQueue.main.async {
//                        let marker = GMSMarker()
//                        marker.position = CLLocationCoordinate2D(latitude: BakeryModelController.shared.bakery?.geometry.location.lat ?? 0, longitude: BakeryModelController.shared.bakery?.geometry.location.lng ?? 0)
//                        marker.icon = GMSMarker.markerImage(with: .roseRed)
//                        marker.title = "\(BakeryModelController.shared.bakery!.name)"
//                        marker.snippet = "\(BakeryModelController.shared.bakery!.formattedAddress)"
//                        marker.map = self.mapView
//                    }
//                }
//            }
//        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        //marker.position

        //bakeryDetailViewController.bakery =
        
        BakeryModelController.shared.currentBakeryName = marker.title
        BakeryModelController.shared.currentBakeryAddress = marker.snippet
        
        performSegue(withIdentifier: "showDetailViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = segue.destination as? BakeryDetailViewController else { return }
    }
    
}
