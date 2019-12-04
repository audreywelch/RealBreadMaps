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

}
