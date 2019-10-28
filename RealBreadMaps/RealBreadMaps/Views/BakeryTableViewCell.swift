//
//  BakeryTableViewCell.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 10/25/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit

class BakeryTableViewCell: UITableViewCell {

    static let reuseIdentier = "bakeryCell"
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            
            // Make container view card-like
            containerView.layer.cornerRadius = 10
            containerView.layer.shadowOpacity = 1
            containerView.layer.shadowRadius = 2
            containerView.layer.shadowColor = UIColor.roseRed.cgColor
            containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
            containerView.backgroundColor = UIColor.systemGray
        }
    }

}
