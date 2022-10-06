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
    
    func verifyForm(with user: User) {
        
        guard let email = user.email, email.count > 0, let password = user.password, password.count > 0 else {
            viewController?.verifyFormFailed()
            return
        }
        
        guard password == user.confirmPassword else {
            viewController?.verifyFormFailed()
            return
        }
        
        viewController.reloadData()
        register(with: email, password: password)
    }
    
    func register(with email: String, password: String) {
        
        self.viewController.setLoading()
        
        AuthenManager.shared.userRegister(with: email, password: password) { result, errorMessage in
            
            if let value = result {
                self.viewController.registerSuccess(user: value)
            }else {
                self.viewController.displayAlert(detail: errorMessage ?? "")
            }
        }
    }
}
