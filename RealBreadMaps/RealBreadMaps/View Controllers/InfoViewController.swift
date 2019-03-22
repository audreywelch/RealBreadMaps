//
//  InfoViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/19/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var webButtonOutlet: UIButton!
    
    @IBAction func webButton(_ sender: Any) {
        if let url = URL(string: (webButtonOutlet.titleLabel?.text)!) {
            UIApplication.shared.open(url, options: [:])
        }
        
        
    }
    
    
}
