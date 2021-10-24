//
//  FirebaseHelper.swift
//  SubMan
//
//  Created by Hosny Savage on 23/10/2021.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

typealias FirebaseAuthResult = AuthDataResult

protocol FirebaseHelperProtocol {
    func getCredentialFromGoogle(with googleUser: GIDGoogleUser) -> AuthCredential
    func getCredentialFromApple(with idToken: String, nonce: String) -> AuthCredential
    func loginUser(credential: AuthCredential, completion: @escaping (AuthDataResult?, Error?) -> Void)
}

class FirebaseHelper: FirebaseHelperProtocol {

    func loginUser(credential: AuthCredential, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(with: credential) { (result, error) in
            completion(result, error)
        }
    }

    func getCredentialFromGoogle(with googleUser: GIDGoogleUser) -> AuthCredential {
        let authentication = googleUser.authentication
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication.idToken)!, accessToken: (authentication?.accessToken)!)
        return credential
    }

    func getCredentialFromApple(with idToken: String, nonce: String) -> AuthCredential {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: nonce)
        return credential
    }

}
