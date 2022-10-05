//
//  AuthService.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import Alamofire
import AlamofireObjectMapper
import SwiftyJSON

public class AuthenService {
    
    public static func userLogin(with email: String, password: String,
                                 completion: @escaping (_ success: Bool, _ errorMessage: String?, _ result: String?)-> Void) {
        
        let request = AuthenRouter.login(email: email, password: password)
        
        APIRequest.request(withRouter: request) { response, error in
            
            if let value = response {
                
                let data = JSON(value)
                let success = data["success"].boolValue
                let error = data["error"].stringValue
                
                let value = data["data"].dictionaryValue
                
                completion(success, error, value["accessToken"]?.stringValue)
                
            }else {
                
                completion(false, nil, nil)
            }
        }
    }
}
