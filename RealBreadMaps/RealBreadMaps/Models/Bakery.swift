//
//  Bakery.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/19/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit
import CoreLocation

struct Bakery: Codable {
    
    let name: String
    let placeId: String
    let geometry: Geometry
    let formattedAddress: String
    let internationalPhoneNumber: String?
    let website: String?
    let openingHours: OpeningHours?
    let photos: [PhotoReferences]?
    
}

struct Geometry: Codable {
    let location: Location
}

struct Location: Codable {
    let lat: Double
    let lng: Double
}

struct OpeningHours: Codable {
    let weekdayText: [String]
}

struct PhotoReferences: Codable {
    let photoReference: String
}

struct BakeryResult: Codable {
    let result: Bakery
}

