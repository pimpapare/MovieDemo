//
//  LoginViewModel.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit

class LoginViewModel: NSObject {
    
    var viewController: LoginViewController!
    
    required init(view: LoginViewController) {
        self.viewController = view
    }
}

extension LoginViewModel {
    
    func verifyForm(with user: User) {
        
        guard let email = user.email, email.count > 0, let password = user.password, password.count > 0 else {
            viewController?.verifyFormFailed()
            return
        }
        
        userLogin(with: email, password: password)
    }
    
    func userLogin(with email: String, password: String) {
        
        AuthenManager.shared.userSignin(with: email, password: password) { user, errorMessage in
 
            if let _ = user {
                self.viewController?.loginSuccess()
            }else {
                self.viewController.displayAlert(detail: errorMessage ?? "")
            }
        }
    }
}
