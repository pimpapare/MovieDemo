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
        
        MovieRemote.shared.fetchAnime(with: name) { success, errorMessage, result in
            
            if let value = result {
                
                MovieLocal.shared.removeMovies()
                
                let savedMovies = MovieLocal.shared.saveMovies(from: value)
                completion(success, errorMessage, savedMovies)
                
            }else {
                
                completion(success, errorMessage, nil)
            }
        }
    }

    func updateMovieStatus(with movie: MD_Movie, isFavorite: Bool, completion: @escaping (_ success: Bool, _ errorMessage: String?, _ result: [MD_Movie]?)-> Void) {
        
        
    }
}
