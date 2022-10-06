//
//  MovieCell.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit
import SDWebImage

protocol MovieDelegate {
    
    func userDidTappedFav(with movie: MD_Movie)
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
    var currentMovie: MD_Movie?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareView()
    }
    
    func prepareView() {
        
        widthVLeft.constant = Constants.Padding.Field
        
        imgCell.layer.cornerRadius = 10
        imgCell.clipsToBounds = true
        imgCell.contentMode = .scaleAspectFill

        setTitle(with: nil)
        setDetail(with: nil)
        setScore(with: nil)
    }
    
    func prepareCell(with movie: MD_Movie?) {
        
        currentMovie = movie
        
        setTitle(with: movie?.title ?? "")
        setDetail(with: movie?.synopsis ?? "")
        setImage(with: movie?.image ?? "")
        setFavIcon(isFav: movie?.isFav ?? false)
        
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
    
    func setFavIcon(isFav: Bool) {
        
        updateBtnFav(isSelected: isFav)
    }
    
    @IBAction func btnFavDidTapped(_ sender: Any) {
        
        guard let value = currentMovie else { return }
        
        delegate?.userDidTappedFav(with: value)
        updateBtnFav(isSelected: value.isFav)
    }
    
    func updateBtnFav(isSelected: Bool) {
        
        let imageName = isSelected ? "starlight" : "star"
        btnFav.setImage(UIImage(named: imageName), for: .normal)
    }
}
