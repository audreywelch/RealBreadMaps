//
//  FirebaseItem.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 12/2/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import Foundation

// Protocol that makes the firebase networking code reusable
// Anything conforming to FirebaseItem has to have a record identifier that is a string
protocol FirebaseItem: class {
    var recordIdentifier: String { get set }
}
