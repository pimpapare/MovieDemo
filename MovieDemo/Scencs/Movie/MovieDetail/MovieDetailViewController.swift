//
//  MovieDetailViewController.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit
import Material
import SafariServices

protocol MovieDetailDelegate {
    
    func hasUpdateMovieStatus(with movie: MD_Movie?)
}

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var widthVLeft: NSLayoutConstraint!

    @IBOutlet weak var vFooter: UIView!
    @IBOutlet weak var btnOpenWebsite: Button!
    @IBOutlet weak var btnFav: Button!
        
    lazy var viewModel: MovieDetailViewModel = {
        return MovieDetailViewModel(view: self)
    }()
        
    static let identifier = "MovieDetailViewController"
    
    var delegate: MovieDetailDelegate?
    
    var movie: MD_Movie?
    var hasChange: Bool = false
    
    lazy var user: MD_User? = {
        return AuthenManager.shared.fetchUser()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAppearance()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if hasChange {
            delegate?.hasUpdateMovieStatus(with: movie)
        }
    }
    
    func prepareAppearance() {
        
        prepareView()
    }
    
    func prepareView() {
        
        title = "Detail"
        widthVLeft.constant = Constants.Padding.Field
        
        btnOpenWebsite.setTitle("Open Website", for: .normal)
        btnOpenWebsite.setTitleColor(.green, for: .normal)
        btnOpenWebsite.layer.borderWidth = 1
        btnOpenWebsite.layer.borderColor = UIColor.green.cgColor
        btnOpenWebsite.layer.cornerRadius = 5
        
        setupBtnFav()
        prepareTableView()
    }
    
    func setupBtnFav() {
        
        let isFav: Bool = (movie?.isFav ?? false)
        let color: UIColor = isFav ? .black : .orange
        
        btnFav.setTitle(isFav ? "Unfavorite" : "Add Favorite", for: .normal)
        btnFav.setTitleColor(color, for: .normal)
        btnFav.layer.borderWidth = 1
        btnFav.layer.borderColor = color.cgColor
        btnFav.layer.cornerRadius = 5
        btnFav.setImage(UIImage(named: "star")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnFav.tintColor = color
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
    
    @IBAction func btnOpenWebsiteDidTapped(_ sender: Any) {
        
        if let urlPath = movie?.url {
            presentSafari(with: urlPath)
        }
    }
        
    func presentSafari(with urlPath: String) {
        
        if let url = URL(string: urlPath) {
            
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self

            present(vc, animated: true)
        }
    }
    
    @IBAction func btnAddToFavDidTapped(_ sender: Any) {
        
        guard let selectedMovie = movie else { return }
        
        selectedMovie.isFav = !selectedMovie.isFav
        updateMovieStatus(with: selectedMovie, userId: user?.userId ?? "")
    }
    
    func updateMovieStatus(with movie: MD_Movie, userId: String) {

        LoadIndicator.showDefaultLoading()
        viewModel.setMovieStatus(with: movie, userId: userId)
    }
    
    func updateMovieStatusSuccess() {
        
        hasChange = true
        LoadIndicator.dismissLoading()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.closeView()
        }
    }
    
    func closeView() {
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension MovieDetailViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
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
        cell?.prepareCell(with: movie)
        return cell!
    }
}
