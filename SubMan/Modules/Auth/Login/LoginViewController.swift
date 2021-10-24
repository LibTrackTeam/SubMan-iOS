//
//  LoginViewController.swift
//  SubMan
//
//  Created by Hosny Savage on 23/10/2021.
//

import UIKit
import Foundation
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController, GIDSignInDelegate, AuthUIDelegate {

    var firebaseHelper: FirebaseHelperProtocol? = FirebaseHelper()
    var cryptHelper = CryptHelper()
    var nonce: String?
    var loginVM: LoginViewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func googleButtonTapped() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }

    @available(iOS 13.0, *)
    func appleButtonTapped() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = get256Sha()

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error != nil {
            self.showAlert(title: "Error", message: "Could not sign in. Please try again later.")
            return
        }
        print("try login")
        firebaseGoogleLogin(with: user)
    }

    func firebaseGoogleLogin(with googleUser: GIDGoogleUser) {
        let credential = firebaseHelper?.getCredentialFromGoogle(with: googleUser)
        firebaseHelper?.loginUser(credential: credential!) { (result, error) in
            self.loginVM.signedIn(error: error, result: result)
        }
    }

    func firebaseAppleLogin(with idToken: String) {
        let credential = firebaseHelper?.getCredentialFromApple(with: idToken, nonce: nonce!)
        firebaseHelper?.loginUser(credential: credential!) { (result, error) in
            self.loginVM.signedIn(error: error, result: result)
        }
    }

    @available(iOS 13, *)
    func get256Sha() -> String {
        self.nonce = cryptHelper.randomNonceString()
        return cryptHelper.sha256(self.nonce!)
    }

    @IBAction func googleSignIn(_ sender: UIButton) {
        googleButtonTapped()
    }

    @available(iOS 13.0, *)
    @IBAction func appleSignIn(_ sender: UIButton) {
        print("tapped")
//        appleButtonTapped()
        //check subscriptions ui
        let vc: SubscriptionsViewController = UIStoryboard(name: "Subscriptions", bundle: nil).instantiateViewController(withIdentifier: "SubscriptionsViewController") as! SubscriptionsViewController
        self.present(vc, animated: true, completion: nil)
    }

}

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
}

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            firebaseAppleLogin(with: idTokenString)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }
}
