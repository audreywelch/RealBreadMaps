//
//  Bakery.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/19/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit
import CoreLocation

//struct Bakery: Decodable {
//
//    // results [] // {}
//    // to be received from the first, Place Search network call
//    var name: String
//    var coordinate: CLLocationCoordinate2D // geometry {} // location {} // lat & lng
//    var formattedAddress: String
//    var placeID: String
//
//    // result {}
//    // to be received from the second, Place Details network call
//    var website: String?
//    var openingHours: String? // opening_hours {} // weekday_text []
//    var photoReferences: String? // photos [] // {} // photo_reference
//
//    // to be received from the last, Photos network call
//    var photos: [UIImage?]
//
//}

struct Bakery {
    
    let name: String
    let coordinate: Geometry
    let formattedAddress: String
    let placeID: String
    let website: String
    let openingHours: OpeningHours
    let photoReferences: [PhotoReferences]
    
}

struct Geometry {
    let location: Location
}

struct Location {
    let lat, long: Double
}

struct OpeningHours {
    let weekdayText: [String]
}

struct PhotoReferences {
    let photoReference: String
}

struct BakeryResult {
    let result: Bakery
}


// initializer with attributes to be received from the first network call
