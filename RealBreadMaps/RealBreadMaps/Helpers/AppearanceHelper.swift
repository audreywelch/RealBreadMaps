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
    
    static let titleFontKokoro = UIFont(name: "KokoroMinchoutai", size: 24)
    static let titleFontPTSerif = UIFont(name: "PTSerif-Regular", size: 24)
    static let titleFontPlayfair = UIFont(name: "PlayfairDisplay-Regular", size: 24)
    static let titleFontOldStandard = UIFont(name: "OldStandardTT-Regular", size: 24)
    static let titleFontAmiri = UIFont(name: "Amiri-Regular", size: 24)
    static let titleFontBoldAmiri = UIFont(name: "Amiri-Bold", size: 24)
    
    
    static func setupTheme() {
        
        // Navigation Bar
        
        UINavigationBar.appearance().barTintColor = .roseRed // .ibisRed
        UIBarButtonItem.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: navigationFont], for: .normal)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: titleFontBoldAmiri]
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().largeTitleTextAttributes = textAttributes
        
        // Tab Bar
        UITabBar.appearance().tintColor = .roseRed // .ibisRed

    }
}
