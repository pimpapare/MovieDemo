//
//  APIConfigs.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import Foundation
import Alamofire

public protocol AlamofireRouterProtocol: URLRequestConvertible {
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

