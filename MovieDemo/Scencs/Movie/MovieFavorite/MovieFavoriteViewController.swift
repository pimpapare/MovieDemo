//
//  MovieFavoriteViewController.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit
import Material

protocol MovieFavoriteDelegate {
    
    func needRefreshMovies()
}

class MovieFavoriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: MovieFavoriteViewModel = {
        return MovieFavoriteViewModel(view: self)
    }()
        
    static let identifier = "MovieFavoriteViewController"
        
    var delegate: MovieFavoriteDelegate?
    var movieList: [MD_Movie]?
    
    var hasUpdate: Bool = false
    var isBack: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        isBack = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAppreance()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if hasUpdate, isBack {
            
            hasUpdate = false
            delegate?.needRefreshMovies()
        }
    }
    
    func prepareAppreance() {
        
        prepareView()
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
}

extension MovieFavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.row < (movieList?.count ?? 0) else { return }

        let movie = movieList?[indexPath.row]
        presentMovieDetail(with: movie)
    }
    
    func presentMovieDetail(with movie: MD_Movie?) {
        
        isBack = false
        
        let identifier = MovieDetailViewController.identifier
        let viewController = UIStoryboard(name: "Movie", bundle: nil).instantiateViewController(withIdentifier: identifier) as? MovieDetailViewController
        viewController?.movie = movie
        viewController?.delegate = self
        viewController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(viewController!, animated: true)
    }
}

extension MovieFavoriteViewController: MovieDetailDelegate {

    func hasUpdateMovieStatus(with updatedMovie: MD_Movie?) {

        if let row = movieList?.firstIndex(where: {$0.title == (updatedMovie?.title ?? "")}) {
            movieList?.remove(at: row)
        }
        
        hasUpdate = true
        reloadData()
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
        
        if (movieList?.count ?? 0 == 0) {
            return 1
        }
        
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
