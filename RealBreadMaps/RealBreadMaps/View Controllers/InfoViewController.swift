//
//  InfoViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/19/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var animationTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateLabel()
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
