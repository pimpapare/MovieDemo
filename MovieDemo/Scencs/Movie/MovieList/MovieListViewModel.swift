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
            return (movie.title ?? "").contains(searchText)
        }
        
        if filterMovie?.count == 0, searchText.count == 0 {
            viewController.filterMovieSuccess(filterList: movies)
        }else {
            viewController.filterMovieSuccess(filterList: filterMovie)
        }
    }
}

extension MovieListViewModel {
    
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
