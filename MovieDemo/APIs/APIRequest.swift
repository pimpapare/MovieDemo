//
//  APIRequest.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import Foundation
import Alamofire

class APIsRequest {
    
    static let shared = APIsRequest()
    
    let timeoutIntervalForRequest = 60.0
    
    lazy var genericSession : Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = APIsRequest.shared.timeoutIntervalForRequest
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }()
    
    func rawRequest(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return Session.default.request(urlRequest).validate(statusCode: 200..<300)
    }
    
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        
        let dataRequest: DataRequest = genericSession.request(urlRequest).validate()
        return dataRequest // require validate to adopt request retrier
    }
}

public class APIRequest {
    
    public typealias completionHandler = (AnyObject?, Error?) -> Void
    
    public static func request(withRouter router: AlamofireRouterProtocol, withHandler handler: @escaping completionHandler)  {
        
        AF.request(router).responseJSON(completionHandler: { response in
            
            debugPrint(response)
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let JSON):
                responseHandler(JSON: JSON as? [String : AnyObject], router: router, completionHandler: handler)
            case .failure(_):
                handler(nil, typeError(statusCode: statusCode))
            }
        })
    }
    
    static func typeError(statusCode:Int?) -> ErrorService {
        
        switch statusCode ?? 0 {
        case 400: return .error400
        case 401: return .error401
        case 403: return .error403
        default: return .error500
        }
    }
    
    public static func responseHandler(JSON: [String : AnyObject]?, router: AlamofireRouterProtocol, completionHandler: APIRequest.completionHandler) {
        
        if let JSON = JSON {
            completionHandler(JSON as AnyObject, nil)
        }else{
            completionHandler(nil,nil)// already debug error
        }
    }
}

public enum ErrorService : Error {
    
    case error500
    case error400
    case error401
    case error403
}

extension ErrorService: LocalizedError {
    
    public var errorDescription: String?{
        
        switch self {
        case .error401: return "Full authentication is required to access this resource"
        case .error400: return "Wrong credentials."
        case .error403: return "Something went wrong. \nPlease try again."
        default: return "Something went wrong. \nPlease try again."
        }
    }
}

public class APIError: LocalizedError {
    
    var status_code = 0
    
    required convenience public init?(status_code: Int) {
        self.init()
        self.status_code = status_code
    }
    
    public var errorDescription: String? {
        switch status_code {
        case 471:
            return NSLocalizedString("error_471", comment: "error")
        case 472:
            return NSLocalizedString("error_472", comment: "error")
        case 473:
            return NSLocalizedString("error_473", comment: "error")
        case 474:
            return NSLocalizedString("error_474", comment: "error")
        case 475:
            return NSLocalizedString("error_475", comment: "error")
        case 401:
            return NSLocalizedString("error_401", comment: "error")
        case 403:
            return NSLocalizedString("error_403", comment: "error")
        case 404:
            return NSLocalizedString("error_404", comment: "error")
        case 405:
            return NSLocalizedString("error_405", comment: "error")
        case 409:
            return NSLocalizedString("error_409", comment: "error")
        case 500:
            return NSLocalizedString("error_500", comment: "error")
        case 501:
            return NSLocalizedString("error_501", comment: "error")
        case 204:
            return NSLocalizedString("error_204", comment: "error")
        default:
            return NSLocalizedString("error_text", comment: "error")
        }
    }
}
