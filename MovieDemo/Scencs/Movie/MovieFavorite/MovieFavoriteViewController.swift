//
//  MovieFavoriteViewController.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit
import Material

class MovieFavoriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: MovieFavoriteViewModel = {
        return MovieFavoriteViewModel(view: self)
    }()
        
    static let identifier = "MovieFavoriteViewController"
        
    var movieList: [MD_Movie]?
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAppreance()
    }
    
    func prepareAppreance() {
        
        prepareView()
        
        viewModel.fetchLocalAnimeList()
        fetchAnime(with: "naruto")
    }
    
    func prepareView() {
        
        title = "Favorite Movies"
        
        prepareTableView()
    }
    
    func prepareTableView() {
        
        tableView.dataSource = self
        
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
        
        tableView.register(FavMovieCell.self, forCellReuseIdentifier: FavMovieCell.identifier)
        tableView.register(UINib(nibName: FavMovieCell.identifier, bundle: nil),
                           forCellReuseIdentifier: FavMovieCell.identifier)
        
        tableView.register(NoDataCell.self, forCellReuseIdentifier: NoDataCell.identifier)
        tableView.register(UINib(nibName: NoDataCell.identifier, bundle: nil),
                           forCellReuseIdentifier: NoDataCell.identifier)
        
        reloadData()
    }
    
    func reloadData() {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func presentSearchPopup() {
        
        let alert = UIAlertController(title: "Movies name", message: "Please enter movie name", preferredStyle: .alert)
        alert.addTextField()
        alert.textFields![0].placeholder = "Movie name"
        
        let submitAction = UIAlertAction(title: "Ok", style: .default) { [unowned alert] _ in
            
            let textfield = alert.textFields![0]
            self.fetchAnime(with: textfield.text ?? "")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [unowned alert] _ in }
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func btnFavMovieDidTapped(_ sender: Any) {
        presentMovieFavoriteView()
    }
    
    func presentMovieFavoriteView() {
        
    }
    
    @IBAction func btnLogoutDidTapped(_ sender: Any) {
        
        viewModel.userLogout()
    }

    func presentLogin() {
     
        let identifier = LoginViewController.identifier
        let viewController = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: identifier) as? LoginViewController
        viewController?.modalPresentationStyle = .fullScreen

        let nav = UINavigationController(rootViewController: viewController!)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
}

extension MovieFavoriteViewController {
    
    func fetchAnime(with text: String) {
        
        viewModel.fetchAnimeList(with: text)
    }
    
    func fetchAnimeSuccess(with movies: [MD_Movie]?) {
        
        movieList = movies
        reloadData()
    }
}

extension MovieFavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movie = movieList?[indexPath.row]
        presentMovieDetail(with: movie)
    }
    
    func presentMovieDetail(with movie: MD_Movie?) {
        
        let identifier = MovieDetailViewController.identifier
        let viewController = UIStoryboard(name: "Movie", bundle: nil).instantiateViewController(withIdentifier: identifier) as? MovieDetailViewController
        viewController?.movie = movie
        viewController?.isFromFavorite = true
        viewController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(viewController!, animated: true)
    }
}

extension MovieFavoriteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (movieList?.count ?? 0) == 0 {
            return tableView.frame.size.height
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.row < (movieList?.count ?? 0) else {
            return prepareNoDataCell()
        }
        
        let movie = movieList?[indexPath.row]
        return prepareMovieCell(with: movie)
    }
    
    func prepareMovieCell(with movie: MD_Movie?) -> UITableViewCell {
        
        let identifier: String = FavMovieCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? FavMovieCell
        cell?.prepareCell(with: movie)
        return cell!
    }
    
    func prepareNoDataCell() -> UITableViewCell {
        
        let identifier: String = NoDataCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoDataCell
        return cell!
    }
}
