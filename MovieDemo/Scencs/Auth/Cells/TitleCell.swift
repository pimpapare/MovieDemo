//
//  TitleCell.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit

class TitleCell: UITableViewCell {

    @IBOutlet weak var txCell: UILabel!
    
    static let identifier = "TitleCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func prepareCell(with text: String) {
        
        txCell.text = text
    }
}
