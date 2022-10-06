//
//  MovieRouter.swift
//  MovieDemo
//
//  Created by Foodstory on 5/10/2565 BE.
//

import Alamofire

enum MovieRouter: AlamofireRouterProtocol {
    
    case getMovie(name: String)
}

extension MovieRouter {
    
    var path: String {
        
        switch self {
        case .getMovie:
            return "anime"
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var baseURLString: String {
        return "https://api.jikan.moe/v4/"
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any]? {
        
        switch self {
        case .getMovie(let name):
            
            let params: [String: Any] = ["q": name]
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
