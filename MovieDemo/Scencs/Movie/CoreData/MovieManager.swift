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
    
    func fetchMovie(of userId: String, with name: String, completion: @escaping (_ success: Bool, _ errorMessage: String?, _ result: [MD_Movie]?)-> Void) {
        
        MovieRemote.shared.fetchMovie(with: name) { success, errorMessage, result in
            
            if let value = result {
                
                self.fetchMovieFavorite(of: userId, allAnieme: value) { success, errorMessage, response in
                    
                    completion(success, errorMessage, response)
                }
                
            }else {
                
                completion(success, errorMessage, nil)
            }
        }
    }
    
    func fetchMovieFavorite(of userId: String, allAnieme: [Movie],
                            completion: @escaping (_ success: Bool, _ errorMessage: String?, _ result: [MD_Movie]?)-> Void) {
        
        guard userId.count > 0 else {
            
            let savedMovies = MovieLocal.shared.saveMovies(from: allAnieme)
            completion(true, nil, savedMovies)
            
            return
        }

        MovieRemote.shared.fetchMovieFavorite(of: userId) { success, errorMessage, result in
            
            MovieLocal.shared.removeMovies()
                        
            if let queries = result {
                
                for document in queries.documents {
                    
                    let data = document.data()
                    let title = data["title"] as? String
                    
                    if let row = allAnieme.firstIndex(where: {$0.title == title}) {
                        allAnieme[row].isFav = true
                        allAnieme[row].documentId = document.documentID
                    }
                }
            }
            
            let savedMovies = MovieLocal.shared.saveMovies(from: allAnieme)
            completion(success, errorMessage, savedMovies)
        }
    }
}

extension MovieManager {
    
    func updateMovieStatus(with movie: MD_Movie, userId: String, completion: @escaping (_ success: Bool, _ errorMessage: String?)-> Void) {
        
        if movie.isFav {
            
            makeAsFavoriteMovie(of: movie, userId: userId) { success, errorMessage, documentId in
                
                if let value = documentId {
                    
                    completion(true, nil)
                    MovieLocal.shared.saveMovieStatus(of: movie, isFav: true, documentId: value)
                }
            }
            
        }else {
            
            var documentId = movie.documentId
            
            if documentId == nil {
                documentId = MovieLocal.shared.fetchMovie(from: movie.title ?? "")?.documentId
            }
            
            guard (documentId?.count ?? 0) > 0 else {
                completion(false, nil)
                return
            }
            
            unMakeAsFavoriteMovie(from: documentId ?? "", userId: userId) { success, errorMessage in
                
                completion(true, nil)
                MovieLocal.shared.saveMovieStatus(of: movie, isFav: false, documentId: "")
            }
        }
    }
    
    func makeAsFavoriteMovie(of movie: MD_Movie, userId: String,
                             completion: @escaping (_ success: Bool, _ errorMessage: String?, _ documentId: String?)-> Void) {
        
        MovieRemote.shared.updateMovieStatus(with: movie, userId: userId) { success, errorMessage, documentId in
            
            completion(success, errorMessage, documentId)
        }
    }
    
    func unMakeAsFavoriteMovie(from documentId: String, userId: String,
                               completion: @escaping (_ success: Bool, _ errorMessage: String?)-> Void) {
        
        MovieRemote.shared.removeFavoriteMovie(from: userId, documentId: documentId) { success, errorMessage in
            
            completion(success, errorMessage)
        }
    }
}
