//
//  FavMovieCell.swift
//  MovieDemo
//
//  Created by Pimpaphorn Chaichompoo on 5/10/2565 BE.
//

import UIKit

class FavMovieCell: UITableViewCell {

    @IBOutlet weak var imgCell: UIImageView!
    
    @IBOutlet weak var txTitle: UILabel!
    @IBOutlet weak var txDetail: UILabel!
    
    @IBOutlet weak var widthVLeft: NSLayoutConstraint!
    
    static let identifier = "FavMovieCell"
    
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
    }

    func prepareCell(with movie: MD_Movie?) {
        
        setTitle(with: movie?.title ?? "")
        setDetail(with: movie?.synopsis ?? "")
        setImage(with: movie?.image ?? "")
    }
    
    func setTitle(with text: String?) {
        txTitle.text = text
    }
    
    func setDetail(with text: String?) {
        txDetail.text = text
    }
    
    func setImage(with imagePath: String) {
        imgCell.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage(named: "logo"), options: .transformAnimatedImage, completed: nil)
    }
}
