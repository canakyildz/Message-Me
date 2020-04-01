//
//  ProfileViewModel.swift
//  Message Me
//
//  Created by Apple on 30.03.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit

enum ProfileViewModel: Int, CaseIterable {
    case accountInfo
    case settings
    
    var description: String {
        switch self {
        case .accountInfo: return "Acount Information"
        case .settings: return "Settings"
    }
    }
    
    var iconImageName: String {
        switch self {
        case .accountInfo: return "person.circle"
        case .settings: return "gear"
        }
    }
}



enum AccountInfoViewOptions: Int, CaseIterable {
    
    case fullname
    case username
    case email

    
    var description: String {
        switch self {
        case .fullname: return "Fullname"
        case .username: return "Username"
        case .email: return "Email"
 
        }
    }
    
    var iconImageName: String {
        switch self {
        case .fullname: return "person.circle.fill"
        case .username: return "person.circle.fill"
        case .email: return "envelope.circle.fill"

        }
    }
    }
    
struct AccountInfoViewModel {
    
    let option: AccountInfoViewOptions
    private let user: User
    
    var descriptionValue: String {
        switch option {
        case .fullname: return user.fullname
        case .username: return user.username.lowercased()
        case .email: return user.email

        }
    }
    
    init(user: User, option: AccountInfoViewOptions) {
        self.user = user
        self.option = option
    }
}
