//
//  InputWithErrorCell.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit

protocol InputWithErrorDelegate {
    
    func userDidUpdateText(text: String, with type: Authen)
}

class InputWithErrorCell: UITableViewCell {
    
    @IBOutlet weak var txError: UILabelError!
    @IBOutlet weak var tfCell: UITextField!
    
    @IBOutlet weak var widthVLeft: NSLayoutConstraint!
    
    static let identifier = "InputWithErrorCell"
    
    var delegate: InputWithErrorDelegate?
    
    var currentType: Authen = .email
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareView()
    }
    
    func prepareView() {
        
        widthVLeft.constant = Constants.Padding.Field

        tfCell.delegate = self
        txError.text = nil
    }
    
    func prepareCell(with type: Authen, user: User?) {
        
        currentType = type
        
        switch currentType {
        case .email:
            setText(with: user?.email)
        case .password:
            setText(with: user?.password)
        case .confirmPassword:
            setText(with: user?.confirmPassword)
        default: break
        }
        
        tfCell.placeholder = type.rawValue
        tfCell.isSecureTextEntry = (type == .password || type == .confirmPassword)
    }
    
    func setText(with text: String?) {
        
        tfCell.text = text
    }
    
    func setError(with type: Authen) {
        
        switch type {
        case .email:
            setErrorText(with: "Please input email")
        case .password:
            setErrorText(with: "Please input password")
        case .confirmPassword:
            setErrorText(with: "Passowrd and confirm password are not match")
        default: break
        }
    }
    
    func setErrorText(with text: String?) {
        
        txError.text = text
    }
    
    func verifyCell(with type: Authen, user: User) {
        
        setErrorText(with: nil)

        switch type {
        case .email:
            
            guard let email = user.email, email.count > 0 else {
                setError(with: .email)
                return
            }
            
            if !email.isValidEmail() {
                setError(with: .email)
            }
            
        case .password:
            
            if (user.password?.count ?? 0) <= 6 {
                setError(with: .password)
            }

        case .confirmPassword:
            
            if (user.confirmPassword?.count ?? 0) <= 0 || user.confirmPassword != user.password {
                setError(with: .confirmPassword)
            }
            
        default:
            break
        }
    }
}

extension InputWithErrorCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let textRange = Range(range, in: text) {
            
            let currentText = text.replacingCharacters(in: textRange, with: string)
            delegate?.userDidUpdateText(text: currentText, with: currentType)
        }
        
        return true
    }
}
