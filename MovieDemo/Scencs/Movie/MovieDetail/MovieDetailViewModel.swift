//
//  MovieDetailViewModel.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit

class MovieDetailViewModel: NSObject {
    
    var viewController: MovieDetailViewController!
    
    required init(view: MovieDetailViewController) {
        self.viewController = view
    }
}

extension MovieDetailViewModel {
    
    func setMovieStatus(with movie: MD_Movie, userId: String) {
        
        MovieManager.shared.updateMovieStatus(with: movie, userId: userId) { success, errorMessage in
            
            self.viewController.updateMovieStatusSuccess()
        }
    }
}
