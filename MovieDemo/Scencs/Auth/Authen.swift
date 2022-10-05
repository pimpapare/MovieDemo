//
//  Authen.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit

enum Authen: String {

    case email = "Email"
    case password = "Password"
    
    case login = "Login"
    case register = "Register"

    case confirmPassword = "Re-password"
}

enum AuthenError: String {
    
    case email = "Plese input email"
    case password = "Please input Password"

    case minimumPassword = "The password must be 6 characters long or more."
    case confirmPassword = "Password don't match"

}
