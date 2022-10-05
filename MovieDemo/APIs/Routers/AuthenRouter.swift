//
//  AuthAPIRouter.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import Alamofire

enum AuthenRouter: AlamofireRouterProtocol {
    
    case login(email: String, password: String)
}

extension AuthenRouter {
    
    var path: String {
        
        switch self {
        case .login:
            return ""
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var baseURLString: String {
        return "https://api.jikan.moe/v4/anime?q=xxxxxx"
    }
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var parameters: [String: Any]? {
        
        switch self {
        case .login(let email, let password):
            
            let params: [String: Any] = ["email": email,
                                         "password": password]
            return params
            
        }
    }
    
    private func setHttpHeaders(_ mutableURLRequest: inout URLRequest, headers: [String: String]?) {

        if let headers = headers {
            for each in headers.keys {
                mutableURLRequest.setValue(headers[each], forHTTPHeaderField: each)
            }
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = URL(string: "\(baseURLString)\(path)")!
        var mutableURLRequest = URLRequest(url: url)
        mutableURLRequest.httpMethod = method.rawValue
        setHttpHeaders(&mutableURLRequest, headers: headers)
        return try URLEncoding.default.encode(mutableURLRequest, with: parameters)
    }
}
