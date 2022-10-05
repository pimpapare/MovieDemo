//
//  ImageCell.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var imgCell: UIImageView!
    
    static let identifier = "ImageCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareView()
    }

    func prepareView() {
        
        imgCell.contentMode = .scaleAspectFit
    }
    
    func prepareCell(with imageName: String) {
        
        imgCell.image = UIImage(named: imageName)
    }
}
