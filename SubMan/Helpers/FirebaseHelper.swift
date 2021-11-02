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
    func authErrorHandler(error: Error?) -> String?
    func getVerifyIDToken(completion: @escaping (String?, Error?) -> Void)
}

class FirebaseHelper: FirebaseHelperProtocol {

    func loginUser(credential: AuthCredential, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(with: credential) { (result, error) in
            completion(result, error)
        }
    }

    func getCredentialFromGoogle(with googleUser: GIDGoogleUser) -> AuthCredential {
        let authentication = googleUser.authentication
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
//        print("CREDS \(credential.)")
        return credential
    }

    func getCredentialFromApple(with idToken: String, nonce: String) -> AuthCredential {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: nonce)
        return credential
    }
    
    func authErrorHandler(error: Error?) -> String? {
        var errorMessage: String?
        if error != nil {
            if let errorCode = AuthErrorCode(rawValue: error!._code) {
                switch errorCode {
                case.wrongPassword:
                    errorMessage = "You entered an invalid password please try again!"
                case .weakPassword:
                    errorMessage = "You entered a weak password. Please choose another!"
                case .emailAlreadyInUse:
                    errorMessage = "An account with this email already exists. Please log in!"
                case .accountExistsWithDifferentCredential:
                    errorMessage = "This account exists with different credentials"
                default:
                    errorMessage = "Unexpected error \(errorCode.rawValue) please try again!"
                }
            }
        }
        if let message = errorMessage {
            return message
        }
        return nil
    }
    
    func getVerifyIDToken(completion: @escaping (String?, Error?) -> Void) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                // Handle error
                print("error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            print("id token: \(String(describing: idToken))")
            let def: UserDefaults = UserDefaults.standard
            def.set(idToken, forKey: "idToken")
            
            completion(idToken, nil)
        }
    }


}
