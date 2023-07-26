//
//  ViewController.swift
//  Vaccination NG
//
//  Created by Mac on 24/07/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var resetPasswordLabel: UILabel!
    @IBOutlet weak var createAccountLabel: UILabel!
    
    let emailIcon = UIImageView()
    let passwordIcon = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loading Basic Designs
        loadBasicDesigns()
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        
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
        
        // Text / Labels Design
        let resetPasswordUnderlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let resetPasswordUnderlineAttributedString = NSAttributedString(string: "Reset Password", attributes: resetPasswordUnderlineAttribute)

        resetPasswordLabel.attributedText = resetPasswordUnderlineAttributedString

        let createAccountUnderlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let createAccountUnderlineAttributedString = NSAttributedString(string: "Create Account", attributes: createAccountUnderlineAttribute)

        createAccountLabel.attributedText = createAccountUnderlineAttributedString
        
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

