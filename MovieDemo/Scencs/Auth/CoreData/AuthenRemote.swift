//
//  AuthenRemote.swift
//  MovieDemo
//
//  Created by Pimpaphorn Chaichompoo on 5/10/2565 BE.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class AuthenRemote: NSObject {
    
    static let shared = AuthenRemote()
}

extension AuthenRemote {
    
    func userRegister(with email: String, password: String,
                      completion: @escaping (_ result: AuthDataResult?, _ errorMessage: String?)-> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            completion(authResult, error?.localizedDescription)
        }
    }
    
    func userSignin(with email: String, password: String,
                    completion: @escaping (_ result: AuthDataResult?, _ errorMessage: String?)-> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            completion(authResult, error?.localizedDescription)
        }
    }
    
    func userSignout(completion: @escaping (_ success: Bool)-> Void) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completion(true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completion(false)
        }
    }
}
