//
//  RegisterViewModel.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit

class RegisterViewModel: NSObject {
    
    var viewController: RegisterViewController!
    
    required init(view: RegisterViewController) {
        self.viewController = view
    }
}

extension RegisterViewModel {
    
    func verifyPassword(with user: User) {
     
        if user.password != user.confirmPassword {
            viewController?.presentErrorConfirmPassword()
        }
    }
}
