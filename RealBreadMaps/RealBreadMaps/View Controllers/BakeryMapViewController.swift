//
//  BreadMapViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/18/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit
import GoogleMaps

class BakeryMapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: - Properties
    
    let bakeryDetailViewController = BakeryDetailViewController()
    
    // Use a CLLocation manager to show user's location
    var locationManager = CLLocationManager()
    var locationCoordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Location retrieval requests
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        
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
            
            // MARK: - 1. Call the following function after each addition to Firebase & 1x per week to update the Firebase with Google info
            // 2. Change rules on Firebase to write: true
            // 3. Uncomment the updateFirebase() call inside getBakeryInfo() function
            // Use the placeID to make the GooglePlaces API call
            //BakeryModelController.shared.getBakeryInfo(with: eachFirebaseBakery.placeID) { (error) in }
            
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Dark mode capability
        if #available(iOS 13.0, *) {
            mapStyling()
        } else {
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
        }
    }
    
    // MARK: - Location Functionality
    
    // Location manager retrieves user's current location and saves it to the Model Controller
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            locationCoordinates = manager.location?.coordinate
            print("LocationCoordinates: \(String(describing: locationCoordinates))")
            
            manager.stopUpdatingLocation()
            
            BakeryModelController.shared.userLocation = location.coordinate
        } else {
            print("User location is unavailable")
            
            BakeryModelController.shared.userLocation = nil
        }

    }
    
    // MARK: - UI Styling
    
    // Function manages alternating between dark and light modes
    func mapStyling() {
        
        if #available(iOS 13.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .dark:
                do {
                    
                    if let styleURL = Bundle.main.url(forResource: "nightStyle", withExtension: "json") {
                        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                    } else {
                        NSLog("Unable to find style.json")
                    }
                } catch {
                    NSLog("One or more of the map styles failed to load. \(error)")
                }
                
            case .light:
                do {
                    
                    if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                    } else {
                        NSLog("Unable to find style.json")
                    }
                } catch {
                    NSLog("One or more of the map styles failed to load. \(error)")
                }
                
            default:
                do {
                    
                    if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                    } else {
                        NSLog("Unable to find style.json")
                    }
                } catch {
                    NSLog("One or more of the map styles failed to load. \(error)")
                }
            }
        }
        
    }
    
    // MARK: - Segue to Detail View Controller

    // Function to segue to the detail view when a marker is tapped
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        // Pass the name of the bakery and the address in order to display correct bakery in detail view
        BakeryModelController.shared.currentBakeryName = marker.title
        BakeryModelController.shared.currentBakeryAddress = marker.snippet
        
        AppStoreReviewManager.requestReviewIfAppropriate()
        
        performSegue(withIdentifier: "showDetailViewController", sender: nil)
    }
    
    // MARK: - Helper Functions
    
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
    
}

