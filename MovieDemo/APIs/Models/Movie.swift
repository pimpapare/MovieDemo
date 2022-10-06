//
//  Movie.swift
//  MovieDemo
//
//  Created by Foodstory on 5/10/2565 BE.
//

import UIKit
import SwiftyJSON

public class Movie: NSObject {
    
    var malId: Int16?
    var documentId: String?

    var title: String?
    var synopsis: String?

    var image: String?
    var smallImage: String?
    var largeImage: String?

    var score: Double?
    
    var url: String?
    var isFav: Bool = false

    init(json: JSON) {
        
        malId = json["mal_id"].int16Value
        title = json["title"].stringValue
        
        let images = json["images"].dictionaryValue
        
        if let imageWebp = images["jpg"]?.dictionaryValue {
            
            image = imageWebp["image_url"]?.stringValue
            smallImage = imageWebp["small_image_url"]?.stringValue
            largeImage = imageWebp["large_image_url"]?.stringValue
        }
        
        synopsis = json["synopsis"].stringValue
        score = json["score"].doubleValue
        url = json["url"].stringValue
    }
}
