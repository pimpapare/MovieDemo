//
//  MovieListViewModel.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit

class MovieListViewModel: NSObject {
    
    var viewController: MovieListViewController!
    
    required init(view: MovieListViewController) {
        self.viewController = view
    }
}

extension MovieListViewModel {
    
    func fetchAnimeList(with name: String) {
        
        MovieManager.shared.fetchAnime(with: name) { success, errorMessage, result in
            
            
        }
    }
}
