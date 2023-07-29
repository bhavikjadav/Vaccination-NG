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
import ProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var reEnterPasswordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    let emailIcon = UIImageView()
    let userIcon = UIImageView()
    let lockIcon = UIImageView()
    let lockIcon2 = UIImageView()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProgressHUD.dismiss()
        
        emailTextField.delegate = self
        phoneNumberField.delegate = self
        passwordField.delegate = self
        
        // Country Code Selection Functionality
        countryCodeTextField.addTarget(self, action:#selector(textDidBeginEditing), for: UIControl.Event.editingDidBegin)
        
        // Loading Basic Designs
        loadBasicDesigns()
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        if let username = userNameTextField.text, let email = emailTextField.text, let countryCode = countryCodeTextField.text, let phoneNumber = phoneNumberField.text, let password = passwordField.text, let reEnteredPassword = reEnterPasswordField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    
                    if !email.validateEmailId() {
                        
                        self.openAlert(title: "Alert", message: "Invalid Email-Id", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay Clicked.")
                        }])
                        
                        self.emailTextField.layer.cornerRadius = 08
                        self.emailTextField.layer.borderWidth = 3
                        self.emailTextField.layer.borderColor = K.colors.dangerColor
                        self.emailTextField.text = ""
                        self.emailTextField.placeholder = "Kindly Provide valid email"
                        
                    } else if phoneNumber.count < 9 {
                        
                        self.openAlert(title: "Alert", message: "Invalid Phone Number", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay Clicked.")
                        }])
                        
                        self.phoneNumberField.layer.cornerRadius = 08
                        self.phoneNumberField.layer.borderWidth = 3
                        self.phoneNumberField.layer.borderColor = K.colors.dangerColor
                        self.phoneNumberField.text = ""
                        self.phoneNumberField.placeholder = "Kindly Provide valid phone number"
                        
                    } else if !password.validatePassword() {
                        
                        self.openAlert(title: "Alert", message: "Choose a Strong Password", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay Clicked.")
                        }])
                        
                        self.passwordField.layer.cornerRadius = 08
                        self.passwordField.layer.borderWidth = 3
                        self.passwordField.layer.borderColor = K.colors.dangerColor
                        self.passwordField.text = ""
                        self.passwordField.placeholder = "Choose a Strong Password"
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
                    self.performSegue(withIdentifier: K.segues.registerToHome, sender: self)
                }
            }
        } else {
            self.openAlert(title: "Alert", message: "Kindly provide neccessary details", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                print("Okay Clicked.")
            }])
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


// MARK: - Country Code Picker Functionality & Basic Design
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
    
    // Custom Design
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
