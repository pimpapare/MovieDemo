//
//  Movie.swift
//  MovieDemo
//
//  Created by Foodstory on 5/10/2565 BE.
//

import UIKit
import SwiftyJSON

public class Movie: NSObject {
    
    var title: String?
    var image: String?
    var score: Double?
    
    init(json: JSON) {
        
        let titles = json["titles"].arrayValue
        
        let titleEn = titles.filter({ titleType in
            return titleType["type"].stringValue.lowercased() == "english"
        }).first
        
        title = titleEn?.stringValue
        
        let images = json["images"].dictionaryValue
        
        if let imageWebp = images["webp"]?.dictionaryValue {
            image = imageWebp["image_url"]?.stringValue
        }
        
        score = json["score"].doubleValue
    }
}
