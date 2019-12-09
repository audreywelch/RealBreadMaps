//
//  FirebaseBakery.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 9/30/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import Foundation
import CoreLocation

struct FirebaseBakery: Codable {
    let milledInHouse: Bool?
    let organic: Bool?
    let placeID: String
    let sellsLoaves: Bool?
    let servesFood: Bool?
    let info: String?
    
    var name: String?
    var lat: Double?
    var lng: Double?
    var formattedAddress: String?
    var internationalPhoneNumber: String?
    var website: String?
    var weekdayText: [String]?
    var photos: [String]?
    
    var distanceFromUser: CLLocationDistance? {
        
        // Complete only if the bakery object has a latitude & longitude
        if self.lat != nil && self.lng != nil {
            
            // Get a CLLocation of the bakery
            BakeryModelController.shared.locationOfBakery = CLLocation(latitude: self.lat!, longitude: self.lng!)
            
            // If the user has shared location, continue
            if BakeryModelController.shared.userLocation != nil {
                
                // Create a CLLocation out of the userLocation
                BakeryModelController.shared.locationOfUser = CLLocation(latitude: BakeryModelController.shared.userLocation.latitude,
                                                                                 longitude: BakeryModelController.shared.userLocation.longitude)
            } 
        }

        // Return the distance from the locationOfUser to the locationOfBakery
        return BakeryModelController.shared.locationOfUser?.distance(from: BakeryModelController.shared.locationOfBakery!)
    }

}
