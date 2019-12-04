//
//  Firebase.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 12/2/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import Foundation

/*
READ   <- Start the application

POST   <- create, creating a new record, Firebase returns a new record identifier
PUT    <- update a specific record
DELETE <- delete a specific record
*/

// Assign an associated type to Firebase called "Item" that will be Codable and be a FirebaseItem
class Firebase<Item: Codable & FirebaseItem> {
    
    static var baseURL: URL! { return URL(string: "https://realbreadmaps.firebaseio.com/") }
    
    // Construct a URL for a method and pass the method as a string
}
