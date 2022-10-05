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
    
    func fetchAnime(with name: String, completion: @escaping (_ success: Bool, _ errorMessage: String?, _ result: [MD_Movie]?)-> Void) {
        
        MovieRemoteDatasource.shared.fetchAnime(with: name) { success, errorMessage, result in
            
            if let value = result {
             
                let savedMovies = MovieLocalDataSoure.shared.saveMovie(from: value)
                completion(success, errorMessage, savedMovies)
                
            }else {
                
                completion(success, errorMessage, nil)
            }
        }
    }
}
