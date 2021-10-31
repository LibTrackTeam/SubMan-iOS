//
//  LoginNavigationController.swift
//  SubMan
//
//  Created by Hosny Savage on 24/10/2021.
//

import Foundation
import UIKit

class LoginNavigationController: UINavigationController {

    enum Screen {
        case login

        var viewController: UIViewController {
            switch self {
            case .login:
                return LoginViewController()
            }
        }
    }

    func navigate(_ to: Screen) {
        DispatchQueue.main.async {
            self.pushViewController(to.viewController, animated: true)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}
