//
//  LaunchViewController.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit

class LaunchViewController: UIViewController {

    var movieViewController: MovieListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        
        verifyAuthen()
    }
    
    func verifyAuthen() {
        
        presentHome()
        
        let user = AuthenManager.shared.fetchUser()
        guard user == nil else { return }

        presentLogin()
    }

    func presentLogin() {
     
        let identifier = LoginViewController.identifier
        let viewController = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: identifier) as? LoginViewController
        viewController?.modalPresentationStyle = .fullScreen
        viewController?.delegate = self
        
        let nav = UINavigationController(rootViewController: viewController!)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    func presentHome() {
        
        let identifier = MovieListViewController.identifier
        movieViewController = UIStoryboard(name: "Movie", bundle: nil).instantiateViewController(withIdentifier: identifier) as? MovieListViewController
        movieViewController?.modalPresentationStyle = .fullScreen
        
        navigationController?.pushViewController(movieViewController!, animated: false)
    }
}

extension LaunchViewController: LoginDelegate {
    
    func loginSuccess(with user: MD_User) {
        
        movieViewController?.user = user
    }
}
