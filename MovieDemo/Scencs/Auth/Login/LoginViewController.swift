//
//  LoginViewController.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    lazy var viewModel: LoginViewModel = {
        return LoginViewModel(view: self)
    }()
    
    static let identifier = "LoginViewController"
    
    var authen: [Authen] = [.email, .password, .login, .register]
    var numberOfRow: Int = 0
    
    var user: User = User()
    var isNeedVerify: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAppearance()
    }
    
    func prepareAppearance() {
        
        prepareView()
    }
    
    func prepareView() {
      
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

        tableView.register(TitleCell.self, forCellReuseIdentifier: TitleCell.identifier)
        tableView.register(UINib(nibName: TitleCell.identifier, bundle: nil),
                           forCellReuseIdentifier: TitleCell.identifier)

        tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.identifier)
        tableView.register(UINib(nibName: ImageCell.identifier, bundle: nil),
                           forCellReuseIdentifier: ImageCell.identifier)

        tableView.register(InputWithErrorCell.self, forCellReuseIdentifier: InputWithErrorCell.identifier)
        tableView.register(UINib(nibName: InputWithErrorCell.identifier, bundle: nil),
                           forCellReuseIdentifier: InputWithErrorCell.identifier)
        
        tableView.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.identifier)
        tableView.register(UINib(nibName: ButtonCell.identifier, bundle: nil),
                           forCellReuseIdentifier: ButtonCell.identifier)
        
        reloadData()
    }
    
    func reloadData() {
                
        numberOfRow = authen.count + 2
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func reloadData(at index: Int) {
        
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
}

extension LoginViewController: UITableViewDelegate {
    
    
}

extension LoginViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            return prepareTitleCell(with: "Anime")
        case 1:
            return prepareImageCell(with: "logo")
        case 2, 3:
            
            let type = authen[indexPath.row - 2]
            return prepareInputFieldCell(with: type)
            
        default:
            
            let type = authen[indexPath.row - 2]
            return prepareButtonCell(with: type)
        }
    }
    
    func prepareTitleCell(with text: String) -> UITableViewCell {
        
        let identifier: String = TitleCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? TitleCell
        cell?.prepareCell(with: text)
        return cell!
    }
    
    func prepareImageCell(with imageName: String) -> UITableViewCell {
        
        let identifier: String = ImageCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ImageCell
        cell?.prepareCell(with: imageName)
        return cell!
    }
    
    func prepareInputFieldCell(with type: Authen) -> UITableViewCell {
        
        let identifier: String = InputWithErrorCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? InputWithErrorCell
        cell?.delegate = self
        cell?.prepareCell(with: type)
        
        if isNeedVerify {
            cell?.verifyCell(with: type, user: user)
        }
        
        return cell!
    }
    
    func prepareButtonCell(with type: Authen) -> UITableViewCell {
        
        let identifier: String = ButtonCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ButtonCell
        cell?.delegate = self
        cell?.prepareCell(with: type)
        
        return cell!
    }
}

extension LoginViewController: InputWithErrorDelegate {
    
    func userDidUpdateText(text: String, with type: Authen) {
        
        switch type {
        case .email:
            user.email = text
        case .password:
            user.password = text
        default: break
        }
    }
}

extension LoginViewController: ButtonDelegate {
    
    func userDidTappedButton(with type: Authen) {

        guard type == .login else {
            presentRegisterView()
            return
        }
        
        viewModel.verifyForm(with: user)
    }
    
    func presentRegisterView() {
        
        let identifier = RegisterViewController.identifier
        let viewController = UIStoryboard(name: "Authen", bundle: nil).instantiateViewController(withIdentifier: identifier) as? RegisterViewController
        viewController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func verifyFormFailed() {
        
        isNeedVerify = true
        reloadData()
    }
    
    func presentHomeView() {
        closeView()
    }
    
    func closeView() {
      
        self.dismiss(animated: true)
    }
}
