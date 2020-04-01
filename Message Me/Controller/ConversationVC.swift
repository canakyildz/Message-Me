//
//  ConversationController.swift
//  Message Me
//
//  Created by Apple on 28.03.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

private let reuseIdentifier = "ConversationCell"

class ConversationVC: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    var users = [User]()
    var conversations = [Conversation]()
    private var conversationsDictioanry = [String: Conversation]()
    
    
    private let newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "newmessage"), for: .normal)
        button.tintColor = .black
        button.imageView?.setDimensions(height: 48, width: 48)
        button.addTarget(self, action: #selector(newMessage), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        authenticateUserAndConfigureUI()
        configureNavigationBar(withTitle: "Conversations", backgroundcolor: .black, titleColor: .white, prefersLargeTitles: true)
        configureNavigation()
        fetchConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar(withTitle: "Conversations", backgroundcolor: .black, titleColor: .white, prefersLargeTitles: true)
        
    }
    
    // MARK: - Selectors
    
    @objc func logOut() {
        do {
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch {
            print(error.localizedDescription)
        }
    }
    @objc func showProfile() {
        let controller = ProfileController(style: .insetGrouped)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func newMessage() {
        let controller = NewMessageVC()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        configureTableView()
        
        view.addSubview(newMessageButton)
        newMessageButton.setDimensions(height: 48, width: 48)
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor , paddingBottom: 16, paddingRight: 24)
    }
    
    func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(showProfile))
        
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginVC()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false, completion: nil)
        }
    }
    // MARK: - API
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginVC())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
            }
        }
    }
    
    func fetchConversations() {
        UserService.fetchConversations { (conversations) in
            
            conversations.forEach { (conversation) in
                let message = conversation.message
                self.conversationsDictioanry[message.chatPartnerId] = conversation
            }
            self.conversations = Array(self.conversationsDictioanry.values)
            self.tableView.reloadData()
        }
    }
    
}
extension ConversationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
}

extension ConversationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user
        let chat = ChatController(user: user)
        navigationController?.pushViewController(chat, animated: true)
    }
}
extension ConversationVC: NewMessageControllerDelegate {
    func controller(_ controller: NewMessageVC, wantsToStartChatWith user: User) {
        controller.dismiss(animated: true) {
            let chat = ChatController(user: user)
            self.navigationController?.pushViewController(chat, animated: true)
        }
    }
}

// MARK: - AuthenticationDelegate

extension ConversationVC: AuthenticationDelegate {
    func authenticationComplete() {
        
        configureUI()
        fetchConversations()
    }
}

// MARK: - ProfileControllerDelegate

extension ConversationVC: ProfileControllerDelegate {
    func handleLogOut() {
        logOut()
    }
}
