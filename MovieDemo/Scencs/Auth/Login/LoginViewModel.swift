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
        
        viewController.reloadData()
        userLogin(with: email, password: password)
    }
    
    func userLogin(with email: String, password: String) {
        
        self.viewController?.setLoading()
        
        AuthenManager.shared.userSignin(with: email, password: password) { result, errorMessage in
 
            if let user = result {
                
                self.viewController?.loginSuccess(with: user)
                
            }else {
                self.viewController.displayAlert(detail: errorMessage ?? "")
            }
        }
    }
}
