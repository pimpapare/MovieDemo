//
//  MovieReponse.swift
//  MovieDemo
//
//  Created by Foodstory on 5/10/2565 BE.
//

import UIKit
import SwiftyJSON

public class MovieReponse: NSObject {
    
    var movies: [Movie]?
    
    init(json: JSON) {
        
        let movieList = json["data"].arrayValue
        
        guard movieList.count > 0 else {
            return
        }
        
        for movie in movieList {
            
            let result = Movie(json: movie)
            
            if movies == nil {
                movies = [Movie]()
            }
            
            movies?.append(result)
        }
    }
}
