//
//  AppearanceHelper.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/22/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit

enum Appearance {
    
    static let mainTextFontTitles = UIFont(name: "Futura Condensed PT", size: 50)
    
    static func setupTheme() {
        
        // Navigation Bar
        
        UINavigationBar.appearance().barTintColor = .ibisRed
        UIBarButtonItem.appearance().tintColor = .white
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: mainTextFontTitles]
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().largeTitleTextAttributes = textAttributes
        
        // Tab Bar
        UITabBar.appearance().tintColor = .ibisRed

    }
}
