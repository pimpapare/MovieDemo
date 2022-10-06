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
    
    public static func getMovie(with name: String, completion: @escaping (_ success: Bool, _ errorMessage: String?, _ result: [Movie]?)-> Void) {
        
        let request = MovieRouter.getMovie(name: name)
        
        APIRequest.request(withRouter: request) { response, error in
            
            if let value = response {
                                
                let data = JSON(value)
                let result = MovieReponse(json: data)
                completion(true, response?.error?.debugDescription, result.movies)
                
            }else {
                
                completion(false, nil, nil)
            }
        }
    }
}
