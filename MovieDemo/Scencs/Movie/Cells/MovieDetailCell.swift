//
//  MovieDetailCell.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit

class MovieDetailCell: UITableViewCell {
    
    @IBOutlet weak var imgMovie: UIImageView!
    
    @IBOutlet weak var txTitle: UILabel!
    @IBOutlet weak var txDetail: UILabel!
    @IBOutlet weak var txScore: UILabel!
    
    @IBOutlet weak var widthVLeft: NSLayoutConstraint!
    
    static let identifier = "MovieDetailCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareView()
    }
    
    func prepareView() {
        
        widthVLeft.constant = Constants.Padding.Field
    }
}
