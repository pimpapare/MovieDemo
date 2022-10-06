//
//  AuthenManager.swift
//  MovieDemo
//
//  Created by Pimpaphorn Chaichompoo on 5/10/2565 BE.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class AuthenManager: NSObject {
    
    static let shared = AuthenManager()
}

extension AuthenManager {
    
    func fetchUser() -> MD_User? {
        
        return AuthenLocal.shared.fetchUser()
    }
    
    func userRegister(with email: String, password: String,
                      completion: @escaping (_ user: MD_User?, _ errorMessage: String?)-> Void) {
        
        AuthenRemote.shared.userRegister(with: email, password: password) { result, errorMessage in
            
            if let value = result {

                let user = AuthenLocal.shared.saveUser(email, userId: value.user.uid)
                completion(user, errorMessage)
                
            }else {
                
                completion(nil, errorMessage)
            }
        }
    }
    
    func userSignin(with email: String, password: String,
                    completion: @escaping (_ user: MD_User?, _ errorMessage: String?)-> Void) {
        
        AuthenRemote.shared.userSignin(with: email, password: password) { result, errorMessage in
            
            if let value = result {
                
                let user = AuthenLocal.shared.saveUser(email, userId: value.user.uid)
                completion(user, errorMessage)
                
            }else {
                
                completion(nil, errorMessage)
            }
        }
    }
    
    func userSignout() {
        
        AuthenRemote.shared.userSignout { success in
         
            if success {
                AuthenLocal.shared.removeUser()
            }
        }
    }
}
