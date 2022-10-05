//
//  MovieListViewController.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit
import Material

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var widthVLeft: NSLayoutConstraint!

    @IBOutlet weak var vFooter: UIView!
    
    @IBOutlet weak var btnFavMovie: Button!
    @IBOutlet weak var btnLogout: Button!
    
    lazy var viewModel: MovieListViewModel = {
        return MovieListViewModel(view: self)
    }()
    
    static let identifier = "MovieListViewController"
    
    var currentName: String = "naruto"
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAppreance()
    }
    
    func prepareAppreance() {
        
        prepareView()
        fetchAnime()
    }
    
    func prepareView() {
        
        title = "Movie"
        widthVLeft.constant = Constants.Padding.Field
        
        vFooter.layer.borderWidth = 1
        vFooter.layer.borderColor = UIColor.gray.cgColor
        
        btnFavMovie.setTitle("Favorate Movies", for: .normal)
        btnFavMovie.setTitleColor(.orange, for: .normal)
        btnFavMovie.layer.borderWidth = 1
        btnFavMovie.layer.borderColor = UIColor.orange.cgColor
        btnFavMovie.layer.cornerRadius = 5
        btnFavMovie.setImage(UIImage(named: "star"), for: .normal)
        
        btnLogout.setTitle("Logout", for: .normal)
        btnLogout.backgroundColor = .red
        btnLogout.layer.cornerRadius = 5
        btnLogout.setTitleColor(.white, for: .normal)
        
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
        
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.register(UINib(nibName: MovieCell.identifier, bundle: nil),
                           forCellReuseIdentifier: MovieCell.identifier)
        
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
}

extension MovieListViewController {
    
    func fetchAnime() {
        
        viewModel.fetchAnimeList(with: currentName)
    }
    
    func fetchAnimeSuccess() {
        
    }
}

extension MovieListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentMovieDetail()
    }
    
    func presentMovieDetail() {
     
        let identifier = MovieDetailViewController.identifier
        let viewController = UIStoryboard(name: "Movie", bundle: nil).instantiateViewController(withIdentifier: identifier) as? MovieDetailViewController
        viewController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(viewController!, animated: true)
    }
}

extension MovieListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return prepareMovieCell()
    }
    
    func prepareMovieCell() -> UITableViewCell {
        
        let identifier: String = MovieCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MovieCell
        return cell!
    }
}
