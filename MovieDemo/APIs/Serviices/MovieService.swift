//
//  MovieService.swift
//  MovieDemo
//
//  Created by Foodstory on 5/10/2565 BE.
//

import Alamofire
import AlamofireObjectMapper
import SwiftyJSON

public class MovieService {
    
    public static func getAnime(with name: String, completion: @escaping (_ success: Bool, _ errorMessage: String?, _ result: [MovieReponse]?)-> Void) {
        
        let request = MovieRouter.getAnime(name: name)
        
        APIRequest.request(withRouter: request) { response, error in
            
            if let value = response {
                                
                let data = JSON(value)
//                let success = data["success"].boolValue
//                let error = data["error"].stringValue
                
                let result = MovieReponse(json: data)
//                completion(success, error, result)
                
            }else {
                
                completion(false, nil, nil)
            }
        }
    }
}
