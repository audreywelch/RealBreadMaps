//
//  AppStoreReviewManager.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/20/20.
//  Copyright © 2020 Audrey Welch. All rights reserved.
//

import StoreKit

enum AppStoreReviewManager {
    
    // Specify number of times the user must perform the review-worthy action
    // Review-worth actions: tap for detail view (either via map or table view)
    static let minimumReviewWorthyActionCount = 5
    
    static func requestReviewIfAppropriate() {
        
        let defaults = UserDefaults.standard
        let bundle = Bundle.main
        
        // Read the current number of actions that user has performed since last requested review from User Defaults
        var actionCount = defaults.integer(forKey: .reviewWorthyActionCount)
        
        // Increment the aciton count value read from User Defaults
        actionCount += 1
        
        // Set incremented count back into the user defaults for next time function is triggered
        defaults.set(actionCount, forKey: .reviewWorthyActionCount)
        
        // Check if action has now exceeded the minimum threshold to trigger a review
        // If not, the function returns
        guard actionCount >= minimumReviewWorthyActionCount else {
            return
        }
        
        // Read the current bundle version and the last bundle version used during the last prompt (if any)
        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
        let lastVersion = defaults.string(forKey: .lastReviewRequestAppVersion)
        
        // Check if this is the first request for this version of the app before continuing
        guard lastVersion == nil || lastVersion != currentVersion else {
            return
        }
        
        // Ask StoreKit to request a review from the user
        SKStoreReviewController.requestReview()
        
        // Reset the action count and store the current version in User Defaults so don't request again on this version of app
        defaults.set(0, forKey: .reviewWorthyActionCount)
        defaults.set(currentVersion, forKey: .lastReviewRequestAppVersion)
    }
}
