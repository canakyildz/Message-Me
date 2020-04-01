//
//  AccountInfoVC.swift
//  Message Me
//
//  Created by Apple on 31.03.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//  There is a bug which allows you put random information on editing side.

import UIKit
import Firebase

protocol AccountInfoControllerDelegate: class {
    func dismissalDelegate(_ controller: AccountInfoVC, wantsToUpdate user: User)
}

private let reuseIdentifier = "AccountInfoCell"

class AccountInfoVC: UITableViewController {
    
    // MARK: - Properties
    
    private var user: User
    var infoChanged = false
    weak var delegate: AccountInfoControllerDelegate?
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    // MARK: - Selectors
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        view.endEditing(true)
        guard infoChanged else { return }
        saveUserData()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        configureNavigationBar(withTitle: "Account Info", backgroundcolor: .black, titleColor: .white, prefersLargeTitles: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(handleSave))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white

        
        tableView.backgroundColor = #colorLiteral(red: 0.9269511421, green: 0.9269511421, blue: 0.9269511421, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.rowHeight = 64
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        
        tableView.register(AccountInfoCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func saveUserData() {
        if infoChanged {
            UserService.saveUserData(user: user) { (err, ref) in
                self.delegate?.dismissalDelegate(self, wantsToUpdate: self.user)
                
                
                
            }
        
        }
    }
    
}

extension AccountInfoVC {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AccountInfoViewOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AccountInfoCell
        guard let option = AccountInfoViewOptions(rawValue: indexPath.row) else { return cell }
        cell.viewModel = AccountInfoViewModel(user: user, option: option)
        cell.delegate = self
        return cell
    }
}

extension AccountInfoVC: AccountInfoCellDelegate {
    func updateUserInfo(_ cell: AccountInfoCell) {

        guard let viewModel = cell.viewModel else { return }
        infoChanged = true
        switch viewModel.option {
            
        case .fullname:
            guard let fullname = cell.infoTextField.text else { return }
            user.fullname = fullname
        case .username:
            guard let username = cell.infoTextField.text else { return }
            user.username = username
            
        case .email:
            guard let email = cell.infoTextField.text else { return }
            user.email = email
            
        }
    }
    
    
}
