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
    
    func filterMovie(with searchText: String, movies: [MD_Movie]?) {
        
        let filterMovie = movies?.filter { movie in
            return (movie.name ?? "").contains(searchText)
        }
        
        if filterMovie?.count == 0, searchText.count == 0 {
            viewController.filterMovieSuccess(filterList: movies)
        }else {
            viewController.filterMovieSuccess(filterList: filterMovie)
        }
    }
}

extension MovieListViewModel {
    
    func fetchAnimeList(with name: String) {
        
        MovieManager.shared.fetchAnime(with: name) { success, errorMessage, result in
            
            self.viewController.fetchAnimeSuccess(with: result)
        }
    }
}
