//
//  AccountInfoCell.swift
//  Message Me
//
//  Created by Apple on 31.03.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

protocol AccountInfoCellDelegate: class {
    func updateUserInfo(_ cell: AccountInfoCell)
}

class AccountInfoCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    var viewModel: AccountInfoViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: AccountInfoCellDelegate?
    
    private lazy var iconView: UIView = {
        let view = UIView()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.centerY(inView: view)
        
        view.backgroundColor = .black
        view.setDimensions(height: 40, width: 40)
        view.layer.cornerRadius = 40/2
        return view
    }()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(height: 28, width: 28)
        iv.tintColor = .white
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var infoTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .right
        tf.textColor = .gray
        tf.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        tf.text = "Test User Attribute"
        return tf
    }()
    
    // MARK: - Lifecycle
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleUpdateUserInfo() {
        delegate?.updateUserInfo(self)
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel])
        stack.spacing = 8
        stack.axis = .horizontal
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        addSubview(infoTextField)
        infoTextField.anchor(top: topAnchor, left: titleLabel.rightAnchor,
                             bottom: bottomAnchor, right: rightAnchor, paddingTop: 11,
                             paddingLeft: 10,paddingBottom: 11, paddingRight: 8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserInfo),
                                               name: UITextView.textDidEndEditingNotification,
                                               object: nil)
        
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        iconImage.image = UIImage(systemName: viewModel.option.iconImageName)
        titleLabel.text = viewModel.option.description
        
        infoTextField.text = viewModel.descriptionValue
    }
    
}
