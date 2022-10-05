//
//  NoDataCell.swift
//  MovieDemo
//
//  Created by Pimpaphorn Chaichompoo on 5/10/2565 BE.
//

import UIKit

class NoDataCell: UITableViewCell {

    @IBOutlet weak var imgCell: UIImageView!
    
    @IBOutlet weak var txTitle: UILabel!
    @IBOutlet weak var txDetail: UILabel!
    
    @IBOutlet weak var widthVLeft: NSLayoutConstraint!
    
    static let identifier = "NoDataCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareView()
    }
    
    func prepareView() {
        
        widthVLeft.constant = Constants.Padding.Field
        
        imgCell.layer.cornerRadius = 10
        imgCell.clipsToBounds = true
        
        setImage(with: "logo")
        setTitle(with: "No data")
        setDetail(with: "No anime cartoon data")
    }
    
    func setTitle(with text: String?) {
        txTitle.text = text
    }
    
    func setDetail(with text: String?) {
        txDetail.text = text
    }
    
    func setImage(with imageName: String?) {
        imgCell.image = UIImage(named: imageName ?? "")
    }
}
