//
//  LoadIndicator.swift
//  MovieDemo
//
//  Created by Pimpaphorn Chaichompoo on 6/10/2565 BE.
//

import UIKit
import SVProgressHUD

class LoadIndicator: NSObject {

    static func showDefaultLoading() {
        
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.show()
    }
    
    static func showLightLoading() {
        
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
        SVProgressHUD.show()
    }
    
    static func dismissLoading() {
        
        SVProgressHUD.dismiss()
    }
}
