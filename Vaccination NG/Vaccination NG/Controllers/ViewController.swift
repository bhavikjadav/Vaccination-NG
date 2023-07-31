//
//  ViewController.swift
//  Vaccination NG
//
//  Created by Mac on 24/07/23.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let loader = ProgressLoading()
    
    // Constants for alert titles and messages
    enum AlertConstants {
        static let alertTitle = "Alert"
        static let invalidEmailPasswordMessage = "Enter Email and Password!"
        static let invalidEmailMessage = "Email Address not found!"
        static let wrongPasswordMessage = "Wrong Password"
        static let emailNotFoundMessage = "Email not found"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loading Basic Designs
        let customLoginVC = CustomLoginViewController()
        customLoginVC.loadBasicDesigns(emailTextField, passwordField, loginButton)
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                    
                    if !email.validateEmailId() && !password.validatePassword() {
                        self.showAlert(title: AlertConstants.alertTitle, message: AlertConstants.invalidEmailPasswordMessage)
                    } else if !email.validateEmailId() {
                        self.showAlert(title: AlertConstants.alertTitle, message: AlertConstants.invalidEmailMessage)
                    } else if e.localizedDescription == "The password is invalid or the user does not have a password." {
                        self.showAlert(title: AlertConstants.alertTitle, message: AlertConstants.wrongPasswordMessage)
                    } else if e.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        self.showAlert(title: AlertConstants.alertTitle, message: AlertConstants.emailNotFoundMessage)
                    }
                } else {
                    self.loader.progressLoading()
                    self.performSegue(withIdentifier: K.segues.loginToHome, sender: self)
                    print("LoggedIn")
                    
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.loginToHome {
            if let sendingToHomeVC = segue.destination as? HomeViewController {
                let sendingEmail = emailTextField.text
                sendingToHomeVC.emailFromLogin = sendingEmail!
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

