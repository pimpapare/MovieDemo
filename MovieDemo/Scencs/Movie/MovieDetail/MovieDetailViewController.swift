//
//  MovieDetailViewController.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit
import Material

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var widthVLeft: NSLayoutConstraint!

    @IBOutlet weak var vFooter: UIView!
    @IBOutlet weak var btnOpenWebsite: Button!
    @IBOutlet weak var btnAddToFav: Button!
    
    static let identifier = "MovieDetailViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAppearance()
    }
    
    func prepareAppearance() {
        
        prepareView()
    }
    
    func prepareView() {
        
        title = "Movie Detail"
        widthVLeft.constant = Constants.Padding.Field

        vFooter.layer.borderWidth = 1
        vFooter.layer.borderColor = UIColor.gray.cgColor
        
        btnOpenWebsite.setTitle("Open Website", for: .normal)
        btnOpenWebsite.setTitleColor(.green, for: .normal)
        btnOpenWebsite.layer.borderWidth = 1
        btnOpenWebsite.layer.borderColor = UIColor.green.cgColor
        btnOpenWebsite.layer.cornerRadius = 5
        
        btnAddToFav.setTitle("Open Website", for: .normal)
        btnAddToFav.setTitleColor(.orange, for: .normal)
        btnAddToFav.layer.borderWidth = 1
        btnAddToFav.layer.borderColor = UIColor.orange.cgColor
        btnAddToFav.layer.cornerRadius = 5
        btnAddToFav.setImage(UIImage(named: "star"), for: .normal)
        
        prepareTableView()
    }
    
    func prepareTableView() {
        
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        
        tableView.bounces = false
        tableView.allowsSelectionDuringEditing = true
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        
        registerCells()
    }
    
    func registerCells() {
        
        tableView.register(MovieDetailCell.self, forCellReuseIdentifier: MovieDetailCell.identifier)
        tableView.register(UINib(nibName: MovieDetailCell.identifier, bundle: nil),
                           forCellReuseIdentifier: MovieDetailCell.identifier)
        
        reloadData()
    }
    
    func reloadData() {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func btnFavMovieDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func btnLogoutDidTapped(_ sender: Any) {
    }
    
    @IBAction func btnOpenWebsiteDidTapped(_ sender: Any) {
    }
    
    @IBAction func btnAddToFavDidTapped(_ sender: Any) {
    }
}

extension MovieDetailViewController: UITableViewDelegate {
 
}

extension MovieDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return prepareMovieDetailCell()
    }
    
    func prepareMovieDetailCell() -> UITableViewCell {
        
        let identifier: String = MovieDetailCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MovieDetailCell
        return cell!
    }
}
