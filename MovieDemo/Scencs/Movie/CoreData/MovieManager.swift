//
//  MovieManager.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit

class MovieManager: NSObject {

    static let shared = MovieManager()

}

extension MovieManager {
    
    func fetchAnime(with name: String, completion: @escaping (_ success: Bool, _ errorMessage: String?, _ result: String?)-> Void) {
        
        MovieRemoteDatasource.shared.fetchAnime(with: name) { success, errorMessage, result in
            
            
            
        }
    }
}
