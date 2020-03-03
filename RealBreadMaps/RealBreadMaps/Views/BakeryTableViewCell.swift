//
//  BakeryTableViewCell.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 10/25/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit

class BakeryTableViewCell: UITableViewCell {

    @IBOutlet weak var bakeryNameLabel: UILabel!
    @IBOutlet weak var bakeryDistanceLabel: UILabel!
    @IBOutlet weak var bakeryAddressLabel: UILabel!
    
    @IBOutlet weak var bakeryImageView: UIImageView!
    
    static let reuseIdentier = "bakeryCell"
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            
            // Make container view card-like
            containerView.layer.cornerRadius = 10
            containerView.layer.shadowOpacity = 1
            containerView.layer.shadowRadius = 2
            containerView.layer.shadowColor = Appearance.Colors.shadow.cgColor // UIColor.lightGray.cgColor
            containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
            containerView.backgroundColor = Appearance.Colors.tableViewCardTint
        }
    }

}
