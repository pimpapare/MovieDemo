//
//  MovieRemoteDatasource.swift
//  MovieDemo
//
//  Created by Foodstory on 5/10/2565 BE.
//

import UIKit

class MovieRemoteDatasource: NSObject {
    
    static let shared = MovieRemoteDatasource()
}

extension MovieRemoteDatasource {
    
    func fetchAnime(with name: String, completion: @escaping (_ success: Bool, _ errorMessage: String?, _ result: [Movie]?)-> Void) {
        
        MovieService.getAnime(with: name) { success, errorMessage, result in
            
            completion(success, errorMessage, result)
        }
    }
}
