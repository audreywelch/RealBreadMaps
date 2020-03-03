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
        
        // Timer for looping animation
        let timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(animateText), userInfo: nil, repeats: true)
        timer.fire()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Animations
    
    @objc func animateText() {
        
        switch animationTextLabel.text {
        case "The FDA allows for 38 different ingredients in its definition of bread...":
            animationTextLabel.text = "... but some believe real bread can be made from 3..."
        case "... but some believe real bread can be made from 3...":
            animationTextLabel.text = "...flour, water, and salt.\n"
        case "...flour, water, and salt.\n":
            animationTextLabel.text = "The FDA allows for 38 different ingredients in its definition of bread..."
        default:
            animationTextLabel.text = "The FDA allows for 38 different ingredients in its definition of bread..."
            
        }
    }
    
    // MARK: - UI
    
    func updateViews() {
        
        self.navigationItem.title = "Real Bread"
        self.tabBarItem.title = "info"
        
        // Fonts
        realBreadExplainedLabel.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: Appearance.thinFont!)
        realBreadExplainedLabel.adjustsFontForContentSizeCategory = true
        aboutMeExplainedLabel.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: Appearance.thinFont!)
        aboutMeExplainedLabel.adjustsFontForContentSizeCategory = true
        realBreadTitleLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: Appearance.infoTitleBoldAmiri!)
        realBreadTitleLabel.adjustsFontForContentSizeCategory = true
        aboutMeTitleLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: Appearance.infoTitleBoldAmiri!)
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
    
    // MARK: - Location Functionality
    
    // Location manager retrieves user's current location and saves it to the Model Controller
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            locationCoordinates = manager.location?.coordinate
            // print("LocationCoordinates: \(String(describing: locationCoordinates))")
            
            manager.stopUpdatingLocation()
            
            BakeryModelController.shared.userLocation = location.coordinate
            
        } else {
            print("User location is unavailable")
            
            BakeryModelController.shared.userLocation = nil
        }

    }

}


