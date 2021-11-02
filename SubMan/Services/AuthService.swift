//
//  AuthService.swift
//  SubMan
//
//  Created by Joseph Acquah on 31/10/2021.
//

import Foundation
import Firebase
import GoogleSignIn
import Alamofire

protocol AuthServiceProtocol {
    func firebaseGoogleLogin(with googleUser: GIDGoogleUser, completion: @escaping (String?, String?) -> Void)
}

class AuthService: AuthServiceProtocol {
    var firebaseHelper: FirebaseHelperProtocol
    var cryptHelper = CryptHelper()
    var nonce: String?
    
    init(helper: FirebaseHelperProtocol = FirebaseHelper()){
        self.firebaseHelper = helper
    }
    
    func firebaseGoogleLogin(with googleUser: GIDGoogleUser, completion: @escaping (String?, String?) -> Void) {
        let credential = firebaseHelper.getCredentialFromGoogle(with: googleUser)
        firebaseHelper.loginUser(credential: credential) { (result, error) in
            if let err = error {
                let errMessage = self.firebaseHelper.authErrorHandler(error: err)
                completion(nil, errMessage)
            } else {
                self.firebaseHelper.getVerifyIDToken(completion: { token, err in
                    completion(token, nil)
                })
            }
        }
    }
    
    private func signIn(user: UserParam){
        AF.request(AuthAPIRouter.signIn(userParam: user)).responseDecodable { (response:DataResponse<UserResponse, AFError>) in
        }
    }
    
}
