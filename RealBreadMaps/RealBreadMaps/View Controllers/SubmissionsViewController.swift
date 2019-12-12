//
//  SubmissionsViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/19/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit
import MessageUI

class SubmissionsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var instagramTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var reasonsTextView: UITextView!
    
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var instagramLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var moreInfoLabel: UILabel!
    
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        locationTextField.delegate = self
        instagramTextField.delegate = self
        websiteTextField.delegate = self
        reasonsTextView.delegate = self
        
        updateViews()
        
        self.hideKeyboard()
    }
    
    func updateViews() {
        
        view.backgroundColor = Appearance.Colors.background
        
        submitButton.tintColor = Appearance.Colors.buttonText //.ibisRed
        reasonsTextView.layer.borderWidth = 0.3
        reasonsTextView.layer.borderColor = UIColor.lightGray.cgColor
        //reasonsTextView.layer.cornerRadius = 7

        introLabel.textColor = Appearance.Colors.label
        nameLabel.textColor = Appearance.Colors.label
        locationLabel.textColor = Appearance.Colors.label
        instagramLabel.textColor = Appearance.Colors.label
        websiteLabel.textColor = Appearance.Colors.label
        moreInfoLabel.textColor = Appearance.Colors.label
        
        nameTextField.backgroundColor = Appearance.Colors.tabBarTint
        locationTextField.backgroundColor = Appearance.Colors.tabBarTint
        instagramTextField.backgroundColor = Appearance.Colors.tabBarTint
        websiteTextField.backgroundColor = Appearance.Colors.tabBarTint
        reasonsTextView.backgroundColor = Appearance.Colors.tabBarTint
        
        submitButton.backgroundColor = Appearance.Colors.background
        submitButton.layer.borderColor = Appearance.Colors.tabBarItemTint.cgColor
        submitButton.layer.borderWidth = 0.3
        //submitButton.layer.cornerRadius = 7
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: Appearance.thinFont], for: .normal)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        submitToGoogleForm()
        
        // Change color of fields to be grayed out
        nameTextField.textColor = .lightGray
        locationTextField.textColor = .lightGray
        instagramTextField.textColor = .lightGray
        websiteTextField.textColor = .lightGray
        reasonsTextView.textColor = .lightGray
            
        // Update submit button text
        submitButton.setTitle("Submitted!", for: .normal)
        submitButton.tintColor = .lightGray
            
//        // Disable text fields and button
//        nameTextField.isEnabled = false
//        locationTextField.isEnabled = false
//        instagramTextField.isEnabled = false
//        websiteTextField.isEnabled = false
//        submitButton.isEnabled = false
//        reasonsTextView.isEditable = false
        
        // Create an Alert Controller to thank user for submitting a bakery
        let ac = UIAlertController(title: "Thank you for sharing your real bread knowledge!", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Add another", style: .cancel) { [weak self] _ in
            
            // Clear text fields
            self?.nameTextField.text = ""
            self?.locationTextField.text = ""
            self?.instagramTextField.text = ""
            self?.websiteTextField.text = ""
            self?.reasonsTextView.text = ""
            
            // Reset text color
            self?.nameTextField.textColor = .black
            self?.locationTextField.textColor = .black
            self?.instagramTextField.textColor = .black
            self?.websiteTextField.textColor = .black
            self?.reasonsTextView.textColor = .black
            
            self?.submitButton.setTitle("Submit", for: .normal)
            self?.submitButton.tintColor = .ibisRed
        })
        
        ac.addAction(UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        })
        
        present(ac, animated: true)
        
    }
    
    // MARK: - Delegate Methods
    
    // UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Hide keyboard when user hits return
        textField.resignFirstResponder()
        
        return true
    }
    
    // UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        reasonsTextView.text = textView.text
        
        if text == "\n" {
            textView.resignFirstResponder()
            
            return false
        }
        return true
    }
    
    // MARK: - Google Forms Submissions
    
    func submitToGoogleForm() {
        
        // Form field IDs
        let nameField = "entry.74565272"
        let locationField = "entry.1183851362"
        let instagramField = "entry.783211295"
        let websiteField = "entry.2031631158"
        let additionalInfo = "entry.934824540"
        
        // URL for filling out a form
        let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfEH-DoMIZgXxIeefSx9tD3j8roy6JgBpx1mGu9k4KNxcLVMw/formResponse")!
        
        // Create URL Request
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        // Add parameters that will make up http body
        var postData = nameField + "=" + (nameTextField.text ?? "Unknown")
        postData += "&" + locationField + "=" + (locationTextField.text ?? "Unknwown")
        postData += "&" + instagramField + "=" + (instagramTextField.text ?? "Unknown")
        postData += "&" + websiteField + "=" + (websiteTextField.text ?? "Unknown")
        postData += "&" + additionalInfo + "=" + (reasonsTextView.text ?? "Unknown")
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData.data(using: String.Encoding.utf8)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
            // Check if there is an error
            if let error = error {
                NSLog("Server POST error: \(error)")
                return
            }
            
            // Check for status response code
            if let response = response as? HTTPURLResponse {
                print("Status Code: \(response.statusCode)")
            }
            
            // Check for data retrieval
            guard let data = data else {
                NSLog("Invalid server response data")
                return
            }
                        
//            if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                print("data: \(dataString)")
//
//                return
//            }
            
        }
        dataTask.resume()
 
    }
    
}

extension UIViewController {
    
    // Hide keyboard when user taps anywhere in the view
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
