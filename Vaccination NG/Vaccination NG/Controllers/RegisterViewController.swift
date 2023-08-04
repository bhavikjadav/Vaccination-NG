//
//  RegisterViewController.swift
//  Vaccination NG
//
//  Created by Mac on 26/07/23.
//

import UIKit
import Planet
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var reEnterPasswordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    let db = Firestore.firestore()
    let loader = ProgressLoading()
    
    // Constants for alert titles and messages
    enum AlertConstants {
        static let alertTitle = "Alert"
        static let invalidEmailMessage = "Email Address not found!"
        static let invalidMobileNoMessage = "Enter valid Contact Number!"
        static let chooseAStrongPasswordMessage = "Choose a Strong Password"
        static let passwordDoesntMatchMessage = "Password doesn't match!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader.dismissLoading()
        
        emailTextField.delegate = self
        phoneNumberField.delegate = self
        passwordField.delegate = self
        
        // Country Code Selection Functionality
        countryCodeTextField.addTarget(self, action:#selector(textDidBeginEditing), for: UIControl.Event.editingDidBegin)
        
        // Loading Basic Designs
        let customDesignVC = CustomRegisterView()
        customDesignVC.loadBasicDesigns(emailTextField, userNameTextField, passwordField, reEnterPasswordField, countryCodeTextField, phoneNumberField)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        if let username = userNameTextField.text, let email = emailTextField.text, let countryCode = countryCodeTextField.text, let phoneNumber = phoneNumberField.text, let password = passwordField.text, let reEnteredPassword = reEnterPasswordField.text {
            
            if reEnteredPassword != password {
                
                self.showAlert(title: AlertConstants.alertTitle, message: AlertConstants.passwordDoesntMatchMessage)
                self.reEnterPasswordField.layer.cornerRadius = 08
                self.reEnterPasswordField.layer.borderWidth = 3
                self.reEnterPasswordField.layer.borderColor = K.colors.dangerColor
                self.reEnterPasswordField.text = ""
                self.reEnterPasswordField.placeholder = AlertConstants.passwordDoesntMatchMessage
                
            } else {
                
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        
                        if !email.validateEmailId() {
                            
                            self.showAlert(title: AlertConstants.alertTitle, message: AlertConstants.invalidEmailMessage)
                            self.emailTextField.layer.cornerRadius = 08
                            self.emailTextField.layer.borderWidth = 3
                            self.emailTextField.layer.borderColor = K.colors.dangerColor
                            self.emailTextField.text = ""
                            self.emailTextField.placeholder = AlertConstants.invalidEmailMessage
                            
                        } else if phoneNumber.count < 9 {
                            
                            self.showAlert(title: AlertConstants.alertTitle, message: AlertConstants.invalidMobileNoMessage)
                            self.phoneNumberField.layer.cornerRadius = 08
                            self.phoneNumberField.layer.borderWidth = 3
                            self.phoneNumberField.layer.borderColor = K.colors.dangerColor
                            self.phoneNumberField.text = ""
                            self.phoneNumberField.placeholder = AlertConstants.invalidMobileNoMessage
                            
                        } else if self.reEnterPasswordField.text != self.passwordField.text {
                            
                            self.showAlert(title: AlertConstants.alertTitle, message: AlertConstants.passwordDoesntMatchMessage)
                            self.reEnterPasswordField.layer.cornerRadius = 08
                            self.reEnterPasswordField.layer.borderWidth = 3
                            self.reEnterPasswordField.layer.borderColor = K.colors.dangerColor
                            self.reEnterPasswordField.text = ""
                            self.reEnterPasswordField.placeholder = AlertConstants.passwordDoesntMatchMessage
                            
                        } else if !password.validatePassword() {
                            
                            self.showAlert(title: AlertConstants.alertTitle, message: AlertConstants.chooseAStrongPasswordMessage)
                            self.passwordField.layer.cornerRadius = 08
                            self.passwordField.layer.borderWidth = 3
                            self.passwordField.layer.borderColor = K.colors.dangerColor
                            self.passwordField.text = ""
                            self.passwordField.placeholder = AlertConstants.chooseAStrongPasswordMessage
                            
                        }
                        
                    } else {
                        
                        // Storing the user's data in the firebase cloud
                        var ref: DocumentReference? = nil
                        ref = self.db.collection("users").addDocument(data: [
                            "username": username,
                            "email": email,
                            "country_code": countryCode,
                            "phone_number": phoneNumber
                        ]) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("Document added with ID: \(ref!.documentID)")
                            }
                        }
                        self.performSegue(withIdentifier: K.segues.registerToVerification, sender: self)
                    }
                }
            }
        }
    }
}

// MARK: - Validations on Text Fields
extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.emailTextField.layer.cornerRadius = 08
        self.emailTextField.layer.borderWidth = 3
        self.emailTextField.layer.borderColor = K.colors.primaryColor
        
        self.passwordField.layer.cornerRadius = 08
        self.passwordField.layer.borderWidth = 3
        self.passwordField.layer.borderColor = K.colors.primaryColor
        
        self.phoneNumberField.layer.cornerRadius = 08
        self.phoneNumberField.layer.borderWidth = 3
        self.phoneNumberField.layer.borderColor = K.colors.primaryColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
    
    // Function that handles Country Code Functionality
    @objc func textDidBeginEditing(sender:UITextField) {
        // handle begin editing event
        let viewController = CountryPickerViewController()
        viewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
}
