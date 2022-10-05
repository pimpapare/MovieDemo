//
//  MovieFavoriteViewModel.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit

class MovieFavoriteViewModel: NSObject {
    
    var viewController: MovieFavoriteViewController!
    
    required init(view: MovieFavoriteViewController) {
        self.viewController = view
    }
}

extension MovieFavoriteViewModel {
    
    func fetchLocalAnimeList() {
    
        let movieList = MovieLocal.shared.fetchMovies()
        self.viewController.fetchAnimeSuccess(with: movieList)
    }
    
    func fetchAnimeList(with name: String) {
        
        MovieManager.shared.fetchAnime(with: name) { success, errorMessage, result in
            
            self.viewController.fetchAnimeSuccess(with: result)
        }
    }
    
    func userLogout() {
        
        AuthenManager.shared.userSignout()
        
        viewController.presentLogin()
    }
}
