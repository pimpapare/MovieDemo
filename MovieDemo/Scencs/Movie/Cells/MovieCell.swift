//
//  MovieCell.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit
import SDWebImage
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
        
        imgCell.layer.cornerRadius = 10
        imgCell.clipsToBounds = true
        
        setTitle(with: nil)
        setDetail(with: nil)
        setScore(with: nil)
    }
    
    func prepareCell(with movie: MD_Movie?) {
        
        setTitle(with: movie?.name ?? "")
        setDetail(with: movie?.detail ?? "")
        setImage(with: movie?.image ?? "")

        if let score = movie?.score, score != 0 {
            setScore(with: String(format: "Score %.2f/10", score))
        }
    }
    
    func setTitle(with text: String?) {
        txTitle.text = text
    }
    
    func setDetail(with text: String?) {
        txDetail.text = text
    }
    
    func setScore(with text: String?) {
        txScore.text = text
    }
    
    func setImage(with imagePath: String) {
        imgCell.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage(named: "logo"), options: .transformAnimatedImage, completed: nil)
    }
    
    @IBAction func btnFavDidTapped(_ sender: Any) {
        delegate?.userDidTappedFav()
    }
}
