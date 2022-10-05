//
//  MovieCell.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit

protocol MovieDelegate {
    
    func userDidTappedFav()
}

class MovieCell: UITableViewCell {

    @IBOutlet weak var txTitle: UILabel!
    @IBOutlet weak var txDetail: UILabel!
    @IBOutlet weak var txScore: UILabel!
    
    @IBOutlet weak var btnFav: UIButton!
    
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var widthVLeft: NSLayoutConstraint!
    
    static let identifier = "MovieCell"
    
    var delegate: MovieDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareView()
    }
    
    func prepareView() {
        
        widthVLeft.constant = Constants.Padding.Field
    }
    
    @IBAction func btnFavDidTapped(_ sender: Any) {
        delegate?.userDidTappedFav()
    }
}
