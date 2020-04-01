//
//  LoginViewModel.swift
//  Message Me
//
//  Created by Apple on 29.03.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import Foundation

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}
struct LoginViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false //it's only true ONLY if both of them is so
    }
}
