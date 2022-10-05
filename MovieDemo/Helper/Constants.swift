//
//  Constraint.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit

struct Constants {

    struct Padding {
        
        static let Field: CGFloat = {
            
            if Constants.isIPad {
                return UIScreen.main.bounds.size.width/8
            }else {
                return 16
            }
        }()
    }
    
    static var isIPad: Bool {
        return UI_USER_INTERFACE_IDIOM() == .pad
    }
}
