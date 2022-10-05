//
//  ButtonCell.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit
import Material

protocol ButtonDelegate {
    
    func userDidTappedButton(with type: Authen)
}

class ButtonCell: UITableViewCell {
    
    @IBOutlet weak var btnCell: AppButton!
    @IBOutlet weak var leftBtnCell: NSLayoutConstraint!
    @IBOutlet weak var rightBtnCell: NSLayoutConstraint!
    @IBOutlet weak var widthVLeft: NSLayoutConstraint!
    
    static let identifier = "ButtonCell"
    
    var delegate: ButtonDelegate?
    
    var currentType: Authen = .login
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareView()
    }
    
    func prepareView() {
        
        widthVLeft.constant = Constants.Padding.Field
    }
    
    func prepareCell(with type: Authen) {

        currentType = type
        setText(with: type.rawValue)
        
        switch type {
        case .login:
            setNormalStyle()
        case .register:
            setBorderStyle()
        default: break
        }
    }
    
    func verifyEnableLoginButton(with user: User) {
        
        let isEnable: Bool = ((user.email?.count ?? 0) > 0 && (user.password?.count ?? 0) > 0)
        setEnableButton(isEnable)
    }
    
    func verifyEnableRegisterButton(with user: User) {
        
        let isEnable: Bool = ((user.email?.count ?? 0) > 0 && (user.password?.count ?? 0) > 0 && (user.confirmPassword?.count ?? 0) > 0)
        setEnableButton(isEnable)
    }
    
    func setEnableButton(_ isEnable: Bool) {
        
        btnCell.isEnabled = isEnable
        btnCell.backgroundColor = isEnable ? .black : UIColor.lightGray
        btnCell.alpha = isEnable ? 1 : 0.9
    }
    
    func setText(with text: String) {
        
        btnCell.setTitle(text, for: .normal)
    }
    
    func setBorderStyle() {
                
        btnCell.backgroundColor = .clear
        btnCell.setTitleColor(.black, for: .normal)

        btnCell.layer.borderWidth = 1
        btnCell.layer.borderColor = UIColor.black.cgColor
    }
    
    func setNormalStyle() {

        leftBtnCell.constant = 0
        rightBtnCell.constant = 0

        btnCell.backgroundColor = .black
        btnCell.setTitleColor(.white, for: .normal)
        
        btnCell.layer.borderWidth = 0
    }
    
    @IBAction func buttonDidTapped(_ sender: Any) {
        delegate?.userDidTappedButton(with: currentType)
    }
}
