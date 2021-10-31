//
//  AuthRepository.swift
//  SubMan
//
//  Created by Joseph Acquah on 31/10/2021.
//

import Foundation
import Firebase
import GoogleSignIn

protocol AuthRepositoryProtocol {
    func firebaseGoogleSignIn(with googleUser: GIDGoogleUser, completion: @escaping (String?, String?) -> Void)
}

class AuthRepository: AuthRepositoryProtocol {
    var authService: AuthServiceProtocol
    
    init(service: AuthServiceProtocol = AuthService()) {
        self.authService = service
    }
    
    func firebaseGoogleSignIn(with googleUser: GIDGoogleUser, completion: @escaping (String?, String?) -> Void) {
        authService.firebaseGoogleLogin(with: googleUser, completion: completion)
    }
}
