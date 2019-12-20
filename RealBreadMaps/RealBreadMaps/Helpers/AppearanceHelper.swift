//
//  AppearanceHelper.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/22/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit

enum Appearance {
    
    // Non-Serif font
    static let mainTextFontTitles = UIFont(name: "FuturaCondensedPT-Medium", size: 36)
    static let tableViewFontTitles = UIFont(name: "Futura-Medium", size: 17)
    static let thinFont = UIFont(name: "FuturaBT-Light", size: UIFont.labelFontSize)
    static let thinSmallFont = UIFont(name: "FuturaBT-Light", size: 15)
    
    // Serif font
    static let titleFontBoldAmiri = UIFont(name: "Amiri-Bold", size: 24)
    static let titleFontAmiri = UIFont(name: "Amiri-Regular", size: 24)
    
    // Font for navigation bars
    static let navigationFont = UIFont(name: "FuturaBT-Light", size: UIFont.labelFontSize)

    
    // SAMPLE FONTS
    static let titleFontKokoro = UIFont(name: "KokoroMinchoutai", size: 24)
    static let titleFontPTSerif = UIFont(name: "PTSerif-Regular", size: 24)
    static let titleFontPlayfair = UIFont(name: "PlayfairDisplay-Regular", size: 24)
    static let titleFontOldStandard = UIFont(name: "OldStandardTT-Regular", size: 24)
    
    
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
        UITabBar.appearance().tintColor = .roseRed //Colors.tabBarItemTint //.roseRed
        UITabBar.appearance().barTintColor = Colors.tabBarTint
        
        // Text Fields / Views
        UITextField.appearance().font = thinFont
        UITextView.appearance().font = thinFont

    }
    
    public enum Colors {
        
        // Custom UIColor Wrapper
        public static let label: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.label
            } else {
                return .black
            }
        }()
        
        public static let background: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.systemBackground
            } else {
                return .white
            }
        }()
        
        public static var tint: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                    if UITraitCollection.userInterfaceStyle == .dark {
                        // Return color for Dark Mode
                        return #colorLiteral(red: 0.9921568627, green: 0.7555645778, blue: 0.6809829309, alpha: 1)
                    } else {
                        // Return color for Light Mode
                        return .roseRed
                    }
                }
            } else {
                // Return fallback color for iOS 12 and lower
                return .roseRed
            }
        }()
        
        public static var tabBarItemTint: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                    if UITraitCollection.userInterfaceStyle == .dark {
                        // Return color for Dark Mode
                        return #colorLiteral(red: 0.9921568627, green: 0.8674790888, blue: 0.7740682373, alpha: 1)
                    } else {
                        // Return color for Light Mode
                        return .roseRed
                    }
                }
            } else {
                // Return fallback color for iOS 12 and lower
                return .roseRed
            }
        }()
        
        public static var tabBarTint: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                    if UITraitCollection.userInterfaceStyle == .dark {
                        // Return color for Dark Mode
                        return .systemGray6
                    } else {
                        // Return color for Light Mode
                        return .white
                    }
                }
            } else {
                // Return fallback color for iOS 12 and lower
                return .white
            }
        }()
        
        public static var tableViewCardTint: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                    if UITraitCollection.userInterfaceStyle == .dark {
                        // Return color for Dark Mode
                        return .systemGray5
                    } else {
                        // Return color for Light Mode
                        return .white
                    }
                }
            } else {
                // Return fallback color for iOS 12 and lower
                return .white
            }
        }()
        
        public static var shadow: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                    if UITraitCollection.userInterfaceStyle == .dark {
                        // Return color for Dark Mode
                        return .systemGray3
                    } else {
                        // Return color for Light Mode
                        return .lightGray
                    }
                }
            } else {
                // Return fallback color for iOS 12 and lower
                return .lightGray
            }
        }()
        
        public static var tagLighterShadow: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                    if UITraitCollection.userInterfaceStyle == .dark {
                        // Return color for Dark Mode
                        return .lightGray
                    } else {
                        // Return color for Light Mode
                        return .gray
                    }
                }
            } else {
                // Return fallback color for iOS 12 and lower
                return .gray
            }
        }()
        
        public static var tagDarkerShadow: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                    if UITraitCollection.userInterfaceStyle == .dark {
                        // Return color for Dark Mode
                        return .gray
                    } else {
                        // Return color for Light Mode
                        return .lightGray
                    }
                }
            } else {
                // Return fallback color for iOS 12 and lower
                return .lightGray
            }
        }()
        
        public static var button: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                    if UITraitCollection.userInterfaceStyle == .dark {
                        // Return color for Dark Mode
                        return .systemGray5
                    } else {
                        // Return color for Light Mode
                        return .roseRed
                    }
                }
            } else {
                // Return fallback color for iOS 12 and lower
                return .roseRed
            }
        }()
        
        public static var buttonText: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                    if UITraitCollection.userInterfaceStyle == .dark {
                        // Return color for Dark Mode
                        return .white
                    } else {
                        // Return color for Light Mode
                        return .roseRed
                    }
                }
            } else {
                // Return fallback color for iOS 12 and lower
                return .roseRed
            }
        }()
    }
}
