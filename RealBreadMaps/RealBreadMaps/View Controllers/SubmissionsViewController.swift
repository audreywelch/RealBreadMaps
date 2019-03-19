//
//  SubmissionsViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/19/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit

class SubmissionsViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var instagramTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var reasonsTextView: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        submitButton.setTitle("Submitted!", for: .normal)
        submitButton.tintColor = .lightGray
    }
    
}
