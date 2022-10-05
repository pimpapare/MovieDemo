//
//  UILabelError.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit

class UILabelError: UILabel {

    override func awakeFromNib() {
        
        prepareView()
    }
    
    func prepareView() {
        
        self.text = nil
        
        self.textColor = .red
        self.font = UIFont.systemFont(ofSize: 13)
    }
}
