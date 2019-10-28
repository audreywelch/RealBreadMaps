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
        
        // Set color for icon
        let markerImage = GMSMarker.markerImage(with: .roseRed)
        
        // Perform the fetch on a background queue
        DispatchQueue.global(qos: .userInitiated).async {
        
            // For each bakery in the firebaseBakeries array
            for eachFirebaseBakery in BakeryModelController.shared.firebaseBakeries {
        
                // Use the placeID to make the GooglePlaces API call
                BakeryModelController.shared.getBakeryInfo(with: eachFirebaseBakery.placeID) { (error) in
                    
                    // Switch to main thread for UI
                    DispatchQueue.main.async {
        
                        // Populate the map with all the bakeries in the Bakeries array
                        for eachBakery in BakeryModelController.shared.bakeries {
                            
                            let marker = GMSMarker()
                            marker.position = CLLocationCoordinate2D(latitude: eachBakery.geometry.location.lat ?? 0, longitude: eachBakery.geometry.location.lng ?? 0)
                            marker.icon = markerImage
                            marker.title = "\(eachBakery.name)"
                            marker.snippet = "\(eachBakery.formattedAddress)"
                            marker.map = self.mapView
                            
                            // MARK: - TODO
                            // Add the following information to markers
                            guard let distanceFromUser = eachBakery.distanceFromUser else { return }
                            print("DISTANCE FROM \(eachBakery.name) is \(BakeryMapViewController.self.convertMetersToMiles(of: distanceFromUser)) miles.")
        
                        }
                    }
                }
            }
        }

    }
    

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        BakeryModelController.shared.currentBakeryName = marker.title
        BakeryModelController.shared.currentBakeryAddress = marker.snippet
        
        performSegue(withIdentifier: "showDetailViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = segue.destination as? BakeryDetailViewController else { return }
    }
    
    
    // Helper function to convert and format distances
    static func convertMetersToMiles(of distance: CLLocationDistance) -> String {
        
        // Local variable to hold distance in order to be manipulated
        var currentDistance = distance
        
        // Convert meters to miles
        currentDistance = currentDistance / 1609.344
        
        // Number Formatter
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        let formattedDistance = formatter.string(from: currentDistance as NSNumber)!
        
        return formattedDistance
        
    }
    
}







        
//        for eachFirebaseBakery in BakeryModelController.shared.firebaseBakeries {
//            for eachBakery in BakeryModelController.shared.bakeries {
//                var temp = eachFirebaseBakery
//                temp.bakeryInfo = eachBakery
//                BakeryModelController.shared.tempFirebaseBakeries.append(temp)
//            }
//        }
//        print("TEMP ARRAY: \(BakeryModelController.shared.tempFirebaseBakeries)")
        
// var bakeryIDs = [BakeryIDS.a, .b, .c, .d, .e, .f, .g, .h, .i, .j, .k, .l, .m, .n, .o, .p, .q, .r, .s, .t, .u, .v, .w, .x, .y, .z, .aa, .bb, .cc, .dd, .ee, .ff, .gg, .hh, .ii, .jj, .kk, .ll]

//        for eachBakeryID in bakeryIDs {
//
//            BakeryModelController.shared.getBakeryInfo(with: eachBakeryID.rawValue) { (error) in
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
