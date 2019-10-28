//
//  GoogleDistance.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 10/25/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import Foundation

struct GoogleDistance: Codable {
    let destinationAddresses: [String]
    let originAddresses: [String]
    let rows: [Row]
    
    enum CodingKeys: String, CodingKey {
        case destinationAddresses = "destination_addresses"
        case originAddresses = "origin_addresses"
        case rows
    }
}

struct Row: Codable {
    let elements: [Element]
}

struct Element: Codable {
    let distance: Distance
    let duration: Distance
}

struct Distance: Codable {
    let text: String
    let value: Int
}