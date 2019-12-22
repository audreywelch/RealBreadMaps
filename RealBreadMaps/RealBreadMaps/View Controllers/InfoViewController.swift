//
//  InfoViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/19/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit
import CoreLocation

class InfoViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var animationTextLabel: UILabel!
    @IBOutlet weak var realBreadExplainedLabel: UILabel!
    @IBOutlet weak var aboutMeExplainedLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var realBreadTitleLabel: UILabel!
    @IBOutlet weak var aboutMeTitleLabel: UILabel!
    
    // Use a CLLocation manager to show user's location
    var locationManager = CLLocationManager()
    var locationCoordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        
        // Location retrieval requests
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        let timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(animateText), userInfo: nil, repeats: true)
        timer.fire()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //animateLabel()
        
        
    }
    
    @objc func animateText() {
        
        switch animationTextLabel.text {
        case "The FDA allows for 38 different ingredients in its definition of bread...":
            animationTextLabel.text = "... but some believe real bread can be made from 3..."
        case "... but some believe real bread can be made from 3...":
            animationTextLabel.text = "...flour, water, and salt."
        case "...flour, water, and salt.":
            animationTextLabel.text = "The FDA allows for 38 different ingredients in its definition of bread..."
        default:
            animationTextLabel.text = "The FDA allows for 38 different ingredients in its definition of bread..."
            
        }
    }
    
    func updateViews() {
        
        self.navigationItem.title = "Real Bread"
        self.tabBarItem.title = "info"
        
        // Fonts
        realBreadExplainedLabel.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: Appearance.thinFont!)
        realBreadExplainedLabel.adjustsFontForContentSizeCategory = true
        aboutMeExplainedLabel.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: Appearance.thinFont!)
        aboutMeExplainedLabel.adjustsFontForContentSizeCategory = true
        realBreadTitleLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: Appearance.submissionBoldAmiri!)
        realBreadTitleLabel.adjustsFontForContentSizeCategory = true
        aboutMeTitleLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: Appearance.submissionBoldAmiri!)
        aboutMeTitleLabel.adjustsFontForContentSizeCategory = true
        
        // Background Colors
        view.backgroundColor = Appearance.Colors.background
        contentView.backgroundColor = Appearance.Colors.background
        
        // Text Colors
        realBreadTitleLabel.textColor = Appearance.Colors.label
        aboutMeTitleLabel.textColor = Appearance.Colors.label
        realBreadExplainedLabel.textColor = Appearance.Colors.label
        aboutMeExplainedLabel.textColor = Appearance.Colors.label
        animationTextLabel.textColor = Appearance.Colors.label
        
    }
    
    // Location manager retrieves user's current location and saves it to the Model Controller
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            locationCoordinates = manager.location?.coordinate
            print("LocationCoordinates: \(String(describing: locationCoordinates))")
            
            manager.stopUpdatingLocation()
            
            BakeryModelController.shared.userLocation = location.coordinate
        } else {
            print("User location is unavailable")
            
            BakeryModelController.shared.userLocation = nil
        }

    }
    
    func animateLabel() {
        
        UIView.animate(withDuration: 5.0, animations: {
            
            // Fade out logo
            self.animationTextLabel.alpha = 0
            
            self.animationTextLabel.text = "The FDA allows for 38 different ingredients in its definition of bread..."
            
            self.animationTextLabel.alpha = 1
            
            //self.animationTextLabel.alpha = 0
            
        }) { (finished) in
            UIView.animate(withDuration: 5.0, animations: {
                
                self.animationTextLabel.alpha = 0
                
                self.animationTextLabel.text = "... but some believe real bread can be made from 3..."
                
                self.animationTextLabel.alpha = 1
                
                //self.animationTextLabel.alpha = 0

            }) { (finished) in
                UIView.animate(withDuration: 5.0, animations: {
                    
                    self.animationTextLabel.alpha = 0
                
                    self.animationTextLabel.text = "...flour, water, and salt."
                
                    self.animationTextLabel.alpha = 1
                
                    //self.animationTextLabel.alpha = 0
                })
            }
        }
        
//
//        UIView.animate(withDuration: 3.0) {
//
//            self.animationTextLabel.alpha = 0
//
//            self.animationTextLabel.text = "Real bread is..."
//
//            self.animationTextLabel.alpha = 1
//
//        }
//
//        UIView.animate(withDuration: 3.0) {
//
//            self.animationTextLabel.alpha = 0
//
//            self.animationTextLabel.text = "Easy to digest..."
//
//            self.animationTextLabel.alpha = 1
//
//        }
//
//        UIView.animate(withDuration: 3.0) {
//
//            self.animationTextLabel.alpha = 0
//
//            self.animationTextLabel.text = "Made with simple ingredients..."
//
//            self.animationTextLabel.alpha = 1
//
//        }
//
//        UIView.animate(withDuration: 3.0) {
//
//            self.animationTextLabel.alpha = 0
//
//            self.animationTextLabel.text = "Absolutely delicious!"
//
//            self.animationTextLabel.alpha = 1
//
//        }
    
    }


}

//extension UILabel {
//    func animate(textString: String, duration: Double) {
//        let characters = textString.map { $0 }
//        var index = 0
//        Timer.scheduledTimer(withTimeInterval: duration, repeats: true, block: { [weak self] timer in
//            if index < textString.count {
//                let char = characters[index]
//                self?.text! += "\(char)"
//                index += 1
//            } else {
//                timer.invalidate()
//            }
//        })
//    }
//}

