//
//  ViewController.swift
//  Vaccination NG
//
//  Created by Mac on 24/07/23.
//

import UIKit
import FirebaseAuth
import ProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let emailIcon = UIImageView()
    let passwordIcon = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loading Basic Designs
        loadBasicDesigns()
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                    if !email.validateEmailId() {
                        
                        self.openAlert(title: "Alert", message: "Email Address not found!", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay Clicked.")
                        }])
                        
                    } else if e.localizedDescription == "The password is invalid or the user does not have a password." {
                        
                        self.openAlert(title: "Alert", message: "Wrong Password", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay Clicked.")
                        }])
                        
                    } else if e.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        
                        self.openAlert(title: "Alert", message: "Email not found", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay Clicked.")
                        }])
                        
                    }
                } else {
//                    let progress = ProgressHUD.animationType = AnimationType.lineSpinFade
                    ProgressHUD.colorAnimation = UIColor.systemBlue
                    ProgressHUD.show()
                    self.performSegue(withIdentifier: K.segues.loginToHome, sender: self)
                    print("LoggedIn")
                    
                }
            }
        } else {
            self.openAlert(title: "Alert", message: "Kindly enter Email and Password", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                print("Okay Clicked.")
            }])
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
    
    func loadBasicDesigns() {
        // Setting up the Icons for Emailand Passwords in the left.
        emailIcon.image = UIImage(named: "mail")
        passwordIcon.image = UIImage(named: "lock")
        
        let emailContentView = UIView()
        let passwordContentView = UIView()
        
        emailContentView.addSubview(emailIcon)
        passwordContentView.addSubview(passwordIcon)
        
        emailContentView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        emailIcon.frame = CGRect(x: -15, y: 0, width: 20, height: 20)
        
        passwordContentView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        passwordIcon.frame = CGRect(x: -15, y: 0, width: 20, height: 20)
        
        emailTextField.rightView = emailContentView
        emailTextField.rightViewMode = .always
        
        passwordField.rightView = passwordContentView
        passwordField.rightViewMode = .always
        
        loginButton.titleLabel?.font = UIFont(name: K.colors.boldFont, size: 20)
        
        // Adding Boarders in Email and Password field
        emailTextField.layer.cornerRadius = 08
        emailTextField.layer.borderWidth = 3
        emailTextField.layer.borderColor = K.colors.primaryColor
        
        passwordField.layer.cornerRadius = 08
        passwordField.layer.borderWidth = 3
        passwordField.layer.borderColor = K.colors.primaryColor
    }
}

