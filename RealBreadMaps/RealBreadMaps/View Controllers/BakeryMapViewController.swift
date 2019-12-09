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
             
        // Set initial view to the the user's location if it's not nil
        if BakeryModelController.shared.userLocation != nil {
            
            let camera = GMSCameraPosition.camera(withLatitude: BakeryModelController.shared.userLocation.latitude,
                                                      longitude: BakeryModelController.shared.userLocation.longitude,
                                                      zoom: 10.0)
            mapView.camera = camera
            mapView.isMyLocationEnabled = true
         
        // Otherwise set initial view to the United States
        } else {
            
            let camera = GMSCameraPosition.camera(withLatitude: 39.0934894, longitude: -94.5815152, zoom: 3.0)
            mapView.camera = camera
        }

        // Set color for icon
        let markerImageColor = GMSMarker.markerImage(with: .roseRed)
        
        // For each bakery retrieved from firebase
        for eachFirebaseBakery in BakeryModelController.shared.firebaseBakeries {
            
            // MARK: - Call the following function after each addition to Firebase & 1x per week to update the Firebase with Google info
            // Also uncomment the updateFirebase() call inside getBakeryInfo() function
            // Use the placeID to make the GooglePlaces API call
            // BakeryModelController.shared.getBakeryInfo(with: eachFirebaseBakery.placeID) { (error) in
            // }
            
            // Ensure UI updates are performed on the main thread
            DispatchQueue.main.async {
                
                // Create a marker
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: eachFirebaseBakery.lat ?? 0, longitude: eachFirebaseBakery.lng ?? 0)
                marker.icon = markerImageColor
                
                // Unwrap names and addresses and assign them to the marker
                if let unwrappedName = eachFirebaseBakery.name {
                    marker.title = "\(unwrappedName)"
                }

                if let unwrappedAddress = eachFirebaseBakery.formattedAddress {
                    marker.snippet = "\(unwrappedAddress)"
                }

                marker.map = self.mapView
            }
        }
        
        // Perform the fetch on a background queue
//        DispatchQueue.global(qos: .userInitiated).async {
//
//            // For each bakery in the firebaseBakeries array
//            //for eachBakeryObject in BakeryModelController.shared.bakeryObjects {
//            for eachFirebaseBakery in BakeryModelController.shared.firebaseBakeries {
//
//                // Use the placeID to make the GooglePlaces API call
//                BakeryModelController.shared.getBakeryInfo(with: eachFirebaseBakery.placeID) { (error) in
//
//                    // Switch to main thread for UI
//                    DispatchQueue.main.async {
//
//                        // Populate the map with all the bakeries in the Bakeries array
//                        for eachBakery in BakeryModelController.shared.bakeries {
//
//                            let marker = GMSMarker()
//                            marker.position = CLLocationCoordinate2D(latitude: eachBakery.geometry.location.lat ?? 0, longitude: eachBakery.geometry.location.lng ?? 0)
//                            marker.icon = markerImageColor
//
//                            marker.title = "\(eachBakery.name)"
//                            marker.snippet = "\(eachBakery.formattedAddress)"
//
//                            // MARK: - TODO
//                            // Come up with new way to add the distance because I need the snippet to be only the address
//
////                            // Unwrap the distance from user
////                            guard let distanceFromUser = eachBakery.distanceFromUser else { return }
////
////                            // If the bakery is in the USA, Liberia, or Myanmar, use miles
////                            if eachBakery.formattedAddress.contains("USA")
////                                || eachBakery.formattedAddress.contains("Liberia")
////                                || eachBakery.formattedAddress.contains("Myanmar") {
////
////                                marker.snippet = "\(eachBakery.formattedAddress)\n👉 \(BakeryMapViewController.self.convertMetersToMiles(of: distanceFromUser)) miles away"
////
////                            // Otherwise, use kilometers
////                            } else {
////                                marker.snippet = "\(eachBakery.formattedAddress)\n👉 \(BakeryMapViewController.self.convertMetersToKilometers(of: distanceFromUser)) kilometers away"
////                            }
//
//                            marker.map = self.mapView
//
//                        }
//                    }
//                }
//            }
//        }

    }

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        BakeryModelController.shared.currentBakeryName = marker.title
        BakeryModelController.shared.currentBakeryAddress = marker.snippet
        
        performSegue(withIdentifier: "showDetailViewController", sender: nil)
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
    
    static func convertMetersToKilometers(of distance: CLLocationDistance) -> String {
        
        // Local variable to hold distance in order to be manipulated
        var currentDistance = distance
        
        // Convert meters to miles
        currentDistance = currentDistance / 1000
        
        // Number Formatter
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        let formattedDistance = formatter.string(from: currentDistance as NSNumber)!
        
        return formattedDistance
    }
    
//    func addBottomSheetView() {
//
//        // Initialize the bottom sheet view controller
//        let bottomSheetVC = BottomSheetViewController()
//
//        // Add Bottom Sheet as a child view
//        self.addChild(bottomSheetVC)
//        self.view.addSubview(bottomSheetVC.view)
//        bottomSheetVC.didMove(toParent: self)
//
//        // Adjust bottom sheet frame and initial position
//        let height = view.frame.height
//        let width = view.frame.width
//        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
//    }
    
}

