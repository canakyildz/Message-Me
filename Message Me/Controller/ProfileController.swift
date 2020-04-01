//
//  ProfileController.swift
//  Message Me
//
//  Created by Apple on 30.03.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol ProfileControllerDelegate: class {
    func handleLogOut()
}

private let reuseIdentifier = "ProfileCell"

class ProfileController: UITableViewController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet { headerView.user = user }
    }
    
    weak var delegate: ProfileControllerDelegate?
    
    var footerView = ProfileFooter()
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0, width: view.frame.width, height: 350))
    
    // MARK: - Lifecycle
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black //even if the bar is hidden,it will give us the status area.
    }
    
    // MARK: - Selectors
    // MARK: - API
    // MARK: - Helpers
    
    func configureUI() {
        tableView.backgroundColor = #colorLiteral(red: 0.9269511421, green: 0.9269511421, blue: 0.9269511421, alpha: 1) 
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 64
        tableView.isScrollEnabled = false
        
        footerView.delegate = self
        footerView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = footerView
        
    }
    
    func fetchUser() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(withUid: currentUid) { (user) in
            self.user = user
        }
    }
    
}

extension ProfileController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        let viewModel = ProfileViewModel(rawValue: indexPath.row)
        cell.viewModel = viewModel
        cell.accessoryType = .disclosureIndicator //arrow
        return cell
    }
}

extension ProfileController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = ProfileViewModel(rawValue: indexPath.row) else { return }
        
        switch viewModel {
        
        case .accountInfo:
            guard let user = user else { return }
            let controller = AccountInfoVC(user: user)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .settings:
            print("show settings")
        }
    }
}
extension ProfileController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { //giving padding between
        return UIView()
    }
}

extension ProfileController: ProfileHeaderDelegate {
    func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileController: ProfileFooterDelegate {
    func logOut() {
        let alert = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            self.dismiss(animated: true) {
                self.delegate?.handleLogOut()
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ProfileController: AccountInfoControllerDelegate {
    func dismissalDelegate(_ controller: AccountInfoVC, wantsToUpdate user: User) {
        dismiss(animated: true, completion: nil)
        self.user = user
        self.tableView.reloadData()
    }
    
    
}
