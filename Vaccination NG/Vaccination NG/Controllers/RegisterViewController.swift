//
//  RegisterViewController.swift
//  Vaccination NG
//
//  Created by Mac on 26/07/23.
//

import UIKit
import Planet

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var reEnterPasswordField: UITextField!
    
    let emailIcon = UIImageView()
    let userIcon = UIImageView()
    let lockIcon = UIImageView()
    let lockIcon2 = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Country Code Selection Functionality
        countryCodeTextField.addTarget(self, action:#selector(textDidBeginEditing), for: UIControl.Event.editingDidBegin)
        
        // Loading Basic Designs
        loadBasicDesigns()
    }
    
    // Function that handles Country Code Functionality
    @objc func textDidBeginEditing(sender:UITextField) {
       // handle begin editing event
        let viewController = CountryPickerViewController()
        viewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    // Loading Bsic Designs
    func loadBasicDesigns() {
        // Setting up the Icons for Emailand Passwords in the left.
        emailIcon.image = UIImage(named: "mail")
        userIcon.image = UIImage(named: "user")
        lockIcon.image = UIImage(named: "lock")
        lockIcon2.image = UIImage(named: "lock")
        
        let emailContentView = UIView()
        let userContentView = UIView()
        let passwordContentView = UIView()
        let reEnterPasswordContentView = UIView()
        
        emailContentView.addSubview(emailIcon)
        userContentView.addSubview(userIcon)
        passwordContentView.addSubview(lockIcon)
        reEnterPasswordContentView.addSubview(lockIcon2)
        
        
        emailContentView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        emailIcon.frame = CGRect(x: -15, y: 0, width: 20, height: 20)
        
        userContentView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        userIcon.frame = CGRect(x: -15, y: 0, width: 20, height: 20)
        
        passwordContentView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        lockIcon.frame = CGRect(x: -15, y: 0, width: 20, height: 20)
        
        reEnterPasswordContentView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        lockIcon2.frame = CGRect(x: -15, y: 0, width: 20, height: 20)
        
        
        emailTextField.rightView = emailContentView
        userNameTextField.rightView = userContentView
        passwordField.rightView = passwordContentView
        reEnterPasswordField.rightView = reEnterPasswordContentView
        
        emailTextField.rightViewMode = .always
        userNameTextField.rightViewMode = .always
        passwordField.rightViewMode = .always
        reEnterPasswordField.rightViewMode = .always
        
        // Adding Boarders in Email and Password field
        emailTextField.layer.cornerRadius = 08
        emailTextField.layer.borderWidth = 3
        emailTextField.layer.borderColor = K.colors.primaryColor
        
        userNameTextField.layer.cornerRadius = 08
        userNameTextField.layer.borderWidth = 3
        userNameTextField.layer.borderColor = K.colors.primaryColor
        
        countryCodeTextField.layer.cornerRadius = 08
        countryCodeTextField.layer.borderWidth = 3
        countryCodeTextField.layer.borderColor = K.colors.primaryColor
        
        phoneNumberField.layer.cornerRadius = 08
        phoneNumberField.layer.borderWidth = 3
        phoneNumberField.layer.borderColor = K.colors.primaryColor
        
        passwordField.layer.cornerRadius = 08
        passwordField.layer.borderWidth = 3
        passwordField.layer.borderColor = K.colors.primaryColor
        
        reEnterPasswordField.layer.cornerRadius = 08
        reEnterPasswordField.layer.borderWidth = 3
        reEnterPasswordField.layer.borderColor = K.colors.primaryColor
        
    }
}

// MARK: - Country Code Picker Functionality
extension RegisterViewController: CountryPickerViewControllerDelegate {
    func countryPickerViewControllerDidCancel(_ countryPickerViewController: Planet.CountryPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func countryPickerViewController(_ countryPickerViewController: Planet.CountryPickerViewController, didSelectCountry country: Planet.Country) {
        countryCodeTextField.text = country.callingCode
        dismiss(animated: true, completion: nil)
    }
    
}
