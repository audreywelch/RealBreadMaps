//
//  SubmissionsViewController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/19/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

import UIKit
import MessageUI

class SubmissionsViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var instagramTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var reasonsTextView: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        locationTextField.delegate = self
        instagramTextField.delegate = self
        websiteTextField.delegate = self
        reasonsTextView.delegate = self
        
        submitButton.tintColor = .ibisRed
        reasonsTextView.layer.borderWidth = 0.3
        reasonsTextView.layer.borderColor = UIColor.lightGray.cgColor
        reasonsTextView.layer.cornerRadius = 7
        
        self.hideKeyboard()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        // If phone has capability of sending mail
        if MFMailComposeViewController.canSendMail() {
            
            // Create instance of mail composer
            let email = MFMailComposeViewController()
            email.mailComposeDelegate = self
            
            // Create text for recipient, subject line, and body
            // </br> for html
            let toRecipient = ["welch.audreyl@gmail.com"]
            let subject = "I found real bread!"
            let body = """
            Name: \(nameTextField.text ?? "Unknown") \n
            Location: \(locationTextField.text ?? "Unknown") \n
            Instagram: \(instagramTextField.text ?? "Unknown") \n
            Website: \(websiteTextField.text ?? "Unknown") \n
            What I love about it: \(reasonsTextView.text ?? "Unknown") \n
            """
            
            // Assign the subject and body to the message
            email.setToRecipients(toRecipient)
            email.setSubject(subject)
            email.setMessageBody(body, isHTML: false)
            
            // Send the email
            present(email, animated: true)
            
            // Change color of fields to be grayed out
            nameTextField.textColor = .lightGray
            locationTextField.textColor = .lightGray
            instagramTextField.textColor = .lightGray
            websiteTextField.textColor = .lightGray
            reasonsTextView.textColor = .lightGray
            
            // Update submit button text
            submitButton.setTitle("Submitted!", for: .normal)
            submitButton.tintColor = .lightGray
            
            // Disable text fields and button
            nameTextField.isEnabled = false
            locationTextField.isEnabled = false
            instagramTextField.isEnabled = false
            websiteTextField.isEnabled = false
            submitButton.isEnabled = false
            reasonsTextView.isEditable = false
          
        // If phone doesn't have mail capability, let the user know with an alert message
        } else {
            
            let alert = UIAlertController(title: "Mail services are not available.", message: "Enable Mail in Settings to use this feature.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            print("Mail services are not available")
            
            return
        }
    }
    
    // MARK: - Delegate Methods
    
    // MFMailComposeViewControllerDelegate Methods
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    // UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
