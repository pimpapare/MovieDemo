//
//  AppButton.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit
import Material

class AppButton: Button {

    override func awakeFromNib() {
        prepareView()
    }
    
    func prepareView() {
        
        self.backgroundColor = .black
        self.layer.cornerRadius = 5
        self.setTitleColor(.white, for: .normal)
    }
}
