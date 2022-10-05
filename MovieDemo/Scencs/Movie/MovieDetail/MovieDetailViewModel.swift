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
