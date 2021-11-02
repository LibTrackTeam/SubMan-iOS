//
//  LoginViewModel.swift
//  SubMan
//
//  Created by Hosny Savage on 23/10/2021.
//

import Foundation
import Firebase
import GoogleSignIn
import Combine

class LoginViewModel {
    @Published var token: String?
    @Published var errorMessage: String?
    var firebaseHelper: FirebaseHelperProtocol
    var cryptHelper = CryptHelper()
    var nonce: String?
    var view: LoginViewController?
    var repo: AuthRepositoryProtocol
    
    init(authRepo: AuthRepositoryProtocol = AuthRepository(), helper: FirebaseHelperProtocol = FirebaseHelper()) {
        self.repo = authRepo
        self.firebaseHelper = helper
    }
    
    func signInAndGetToken(googleUser: GIDGoogleUser) {
        repo.firebaseGoogleSignIn(with: googleUser) { toek, err in
            if let error = err {
                self.errorMessage = error
            } else {
                self.token = toek
            }
        }
    }

    func firebaseAppleLogin(with idToken: String) {
        let credential = firebaseHelper.getCredentialFromApple(with: idToken, nonce: nonce!)
        firebaseHelper.loginUser(credential: credential) { (result, error) in
//            self.signedIn(error: error, result: result)
        }
    }
    
    func get256Sha() -> String {
        self.nonce = cryptHelper.randomNonceString()
        return cryptHelper.sha256(self.nonce!)
    }

}
