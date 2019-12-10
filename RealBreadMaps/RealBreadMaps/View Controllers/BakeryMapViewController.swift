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
            // BakeryModelController.shared.getBakeryInfo(with: eachFirebaseBakery.placeID) { (error) in }
            
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

    }

    // Function to segue to the detail view when a marker is tapped
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
    
    // Helper function to convert meters to kilometers
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

