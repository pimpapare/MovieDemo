//
//  RegisterViewController.swift
//  MovieDemo
//
//  Created by Foodstory on 4/10/2565 BE.
//

import UIKit

protocol RegisterViewDelegate {

    func registerSuccess(with user: MD_User)
}

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    lazy var viewModel: RegisterViewModel = {
        return RegisterViewModel(view: self)
    }()
    
    static let identifier = "RegisterViewController"
    
    var delegate: RegisterViewDelegate?
    
    var authen: [Authen] = [.email, .password, .confirmPassword, .register]
    var numberOfRow: Int = 0
    
    var user: User = User()
    var isNeedVerify: Bool = false

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAppearance()
    }
    
    func prepareAppearance() {
        
        prepareView()
    }
    
    func prepareView() {

        title = "Register"
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
        
        tableView.register(InputWithErrorCell.self, forCellReuseIdentifier: InputWithErrorCell.identifier)
        tableView.register(UINib(nibName: InputWithErrorCell.identifier, bundle: nil),
                           forCellReuseIdentifier: InputWithErrorCell.identifier)
        
        tableView.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.identifier)
        tableView.register(UINib(nibName: ButtonCell.identifier, bundle: nil),
                           forCellReuseIdentifier: ButtonCell.identifier)
        
        reloadData()
    }
    
    func reloadData() {
        
        numberOfRow = authen.count
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.setHeightTableView()
        }
    }
    
    func setHeightTableView() {
        
        var heightTableView = NSLayoutConstraint(item: self.tableView, attribute: .height,
                                             relatedBy: .equal, toItem: self.view,
                                             attribute: .height, multiplier: 0.0, constant: 1000)
        self.view.addConstraint(heightTableView)

        tableView.isScrollEnabled = false

        UIView.animate(withDuration: 0, animations: {
            self.tableView.layoutIfNeeded()
        }) { (complete) in

            var height: CGFloat = 0.0
            let cells = self.tableView.visibleCells

            for cell in cells {
                height += cell.frame.height
            }

            self.heightTableView.constant = height
        }
    }
    
    func reloadData(at index: Int) {
        
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
}

extension RegisterViewController: UITableViewDelegate {
    
    
}

extension RegisterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case (numberOfRow - 1):
            return prepareButtonCell(with: .register)
        default:
            
            let type = authen[indexPath.row]
            return prepareInputFieldCell(with: type)
        }
    }
    
    func prepareInputFieldCell(with type: Authen) -> UITableViewCell {
        
        let identifier: String = InputWithErrorCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? InputWithErrorCell
        cell?.delegate = self
        cell?.prepareCell(with: type, user: user)
        
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
        cell?.setNormalStyle()

        return cell!
    }
}

extension RegisterViewController: InputWithErrorDelegate {
    
    func userDidUpdateText(text: String, with type: Authen) {
        
        switch type {
        case .email:
            user.email = text
        case .password:
            user.password = text
        case .confirmPassword:
            user.confirmPassword = text
        default: break
        }
    }
}

extension RegisterViewController: ButtonDelegate {
    
    func userDidTappedButton(with type: Authen) {
       
        viewModel.verifyForm(with: user)
    }
    
    func verifyFormFailed() {
        
        isNeedVerify = true
        reloadData()
    }
    
    func displayAlert(title: String?=nil, detail: String?=nil) {
        
        let alertController = UIAlertController(title: title, message: detail, preferredStyle: .alert)

        let okeyAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okeyAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func registerSuccess(user: MD_User) {
        
        self.dismiss(animated: true) {
            self.delegate?.registerSuccess(with: user)
        }
    }
}
