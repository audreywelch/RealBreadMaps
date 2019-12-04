//
//  BakeryObject.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 12/2/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import Foundation

class BakeryObject: Codable, FirebaseItem {
    var recordIdentifier: String = ""
    
    let name: String
    let placeId: String
    let lat: Double
    let lng: Double
    let formattedAddress: String
    let internationalPhoneNumber: String?
    let website: String?
    let weekdayText: [String]
    let photos: [String]?
    
    let milledInHouse: Bool?
    let organic: Bool?
    let sellsLoaves: Bool?
    let servesFood: Bool?
    let info: String?
    
    // initializer
    init(name: String, placeId: String, lat: Double, lng: Double, formattedAddress: String, internationalPhoneNumber: String,
         website: String?, weekdayText: [String], photos: [String]?, milledInHouse: Bool?, organic: Bool?, sellsLoaves: Bool?, servesFood: Bool?, info: String?) {
        self.name = name
        self.placeId = placeId
        self.lat = lat
        self.lng = lng
        self.formattedAddress = formattedAddress
        self.internationalPhoneNumber = internationalPhoneNumber
        self.website = website
        self.weekdayText = weekdayText
        self.photos = photos
        self.milledInHouse = milledInHouse
        self.organic = organic
        self.sellsLoaves = sellsLoaves
        self.servesFood = servesFood
        self.info = info
    }
    
}
