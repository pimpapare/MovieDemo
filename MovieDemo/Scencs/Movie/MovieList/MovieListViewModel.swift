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
    
    func filterFavoriteMovie(movies: [MD_Movie]?) -> [MD_Movie]? {
        
        let filterMovie = movies?.filter { movie in
            return movie.isFav == true
        }
        
        return filterMovie
    }
}

extension MovieListViewModel {
    
    func fetchLocalMovieList() {
    
        let movieList = MovieLocal.shared.fetchMovies()
        self.viewController.fetchMovieSuccess(with: movieList)
    }
    
    func fetchMovieList(of userId: String, with name: String) {
        
        MovieManager.shared.fetchMovie(of: userId, with: name) { success, errorMessage, result in
            
            self.viewController.fetchMovieSuccess(with: result)
        }
    }
    
    func userLogout() {
        
        AuthenManager.shared.userSignout()
        
        viewController.presentLogin()
    }
    
    func setMovieStatus(with movie: MD_Movie, userId: String) {
                
        movie.isFav = !movie.isFav
        
        MovieManager.shared.updateMovieStatus(with: movie, userId: userId) { success, errorMessage in
            
            self.viewController.updateMovieStatusSuccess(with: movie)
        }
    }
}
