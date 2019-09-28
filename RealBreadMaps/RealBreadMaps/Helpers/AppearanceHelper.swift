//
//  AppearanceHelper.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/22/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit

enum Appearance {
    
    static let mainTextFontTitles = UIFont(name: "FuturaCondensedPT-Medium", size: 36)
    //(name: "Futura Condensed PT", size: 36)
    static let thinFont = UIFont(name: "FuturaBT-Light", size: UIFont.labelFontSize)
    static let navigationFont = UIFont(name: "FuturaBT-Light", size: UIFont.labelFontSize)
    
    static func setupTheme() {
        
        // Navigation Bar
        
        UINavigationBar.appearance().barTintColor = .ibisRed //.roseRed
        UIBarButtonItem.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: navigationFont], for: .normal)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: mainTextFontTitles]
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().largeTitleTextAttributes = textAttributes
        
        // Tab Bar
        UITabBar.appearance().tintColor = .ibisRed // .roseRed

    }
}
