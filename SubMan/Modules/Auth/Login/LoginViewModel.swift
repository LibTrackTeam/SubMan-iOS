//
//  LoginViewModel.swift
//  SubMan
//
//  Created by Hosny Savage on 23/10/2021.
//

import Foundation
import Firebase
import GoogleSignIn

class LoginViewModel {

    var firebaseHelper: FirebaseHelperProtocol?
    var cryptHelper = CryptHelper()
    var nonce: String?
    var view: LoginViewController?

    init(view: LoginViewController) {
        self.view = view
    }

    func firebaseGoogleLogin(with googleUser: GIDGoogleUser) {
        let credential = firebaseHelper?.getCredentialFromGoogle(with: googleUser)
        firebaseHelper?.loginUser(credential: credential!) { (result, error) in
            self.signedIn(error: error, result: result)
        }
    }

    func firebaseAppleLogin(with idToken: String) {
        let credential = firebaseHelper?.getCredentialFromApple(with: idToken, nonce: nonce!)
        firebaseHelper?.loginUser(credential: credential!) { (result, error) in
            self.signedIn(error: error, result: result)
        }
    }

    func signedIn(error: Error?, result: FirebaseAuthResult?) {
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
            //  display alert message here
            view?.showAlert(title: "Error", message: message)
            return
        }
        // get verified token
        getVerifyIDToken()
    }

    func get256Sha() -> String {
        self.nonce = cryptHelper.randomNonceString()
        return cryptHelper.sha256(self.nonce!)
    }

    func signIn() {
        view?.moveIntoSubscriptions()
    }

    func getVerifyIDToken() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                // Handle error
                print("error: \(error.localizedDescription)")
                return
            }
            print("id token: \(String(describing: idToken))")
            let def: UserDefaults = UserDefaults.standard
            def.set(idToken, forKey: "idToken")
            // Send token to your backend via HTTPS
            // ...
            self.signIn()
        }
    }

}
