//
//  UserDefaults + Key.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/20/20.
//  Copyright © 2020 Audrey Welch. All rights reserved.
//

import Foundation

/*
 Extension on UserDefaults to eliminate the need for using “stringly” typed keys when accessing values.
 Avoids accidentally mistyping a key as it can cause hard-to-find bugs.
 */

extension UserDefaults {
    enum Key: String {
        case reviewWorthyActionCount
        case lastReviewRequestAppVersion
    }
    
    func integer(forKey key: Key) -> Int {
        return integer(forKey: key.rawValue)
    }
    
    func string(forKey key: Key) -> String? {
        return string(forKey: key.rawValue)
    }
    
    func set(_ integer: Int, forKey key: Key) {
        set(integer, forKey: key.rawValue)
    }
    
    func set(_ object: Any?, forKey key: Key) {
        set(object, forKey: key.rawValue)
    }
}
