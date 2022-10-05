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
    var detail: String?

    var image: String?
    var score: Double?
    
    var url: String?
    var isFav: Bool = false

    init(json: JSON) {
        
        let titles = json["titles"].arrayValue
        
        let titleEn = titles.filter({ titleType in
            return titleType["type"].stringValue.lowercased() == "english"
        }).first
        
        title = titleEn?["title"].stringValue
        
        let images = json["images"].dictionaryValue
        
        if let imageWebp = images["jpg"]?.dictionaryValue {
            image = imageWebp["image_url"]?.stringValue
        }
        
        detail = json["synopsis"].stringValue
        score = json["score"].doubleValue
        url = json["url"].stringValue
    }
}
