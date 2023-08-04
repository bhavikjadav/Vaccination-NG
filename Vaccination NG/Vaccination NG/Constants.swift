//
//  Constants.swift
//  Vaccination NG
//
//  Created by Mac on 26/07/23.
//

import UIKit

struct K {
    static let appName = "Vaccination NG"
    
    struct segues {
        static let loginToHome = "loginToHome"
        static let registerToVerification = "registerToVerification"
    }
    
    struct colors {
        static let primaryColor = UIColor(red: 0.090, green: 0.761, blue: 0.925, alpha: 1).cgColor
        static let regularFont = "Montserrat-Regular"
        static let boldFont = "Montserrat-Bold"
        static let dangerColor = UIColor.red.cgColor
    }
}
