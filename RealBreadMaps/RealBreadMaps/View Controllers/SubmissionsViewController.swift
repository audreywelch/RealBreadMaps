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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.tintColor = .ibisRed
        
        self.hideKeyboard()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        nameTextField.textColor = .lightGray
        locationTextField.textColor = .lightGray
        instagramTextField.textColor = .lightGray
        websiteTextField.textColor = .lightGray
        reasonsTextView.textColor = .lightGray
        
        submitButton.setTitle("Submitted!", for: .normal)
        submitButton.tintColor = .lightGray
    }
    
    @IBAction func done(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
