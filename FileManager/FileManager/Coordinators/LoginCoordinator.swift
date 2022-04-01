//
//  LoginCoordinator.swift
//  FileManager
//
//  Created by Natali Malich
//

import UIKit

class LoginCoordinator: CoordinatorProtocol {
    
    weak var parentCoordinator: AppCoordinator?
    let navigationController: UINavigationController
    var childCoordinators = [CoordinatorProtocol]()
    let window: UIWindow?
    private let loginInspector = LoginInspector.shared.keychain.allKeys()
    
    required init(window: UIWindow?) {
        self.window = window
        self.navigationController = .init()
    }
    
    func openLoginViewController() {
        if loginInspector.isEmpty {
            let loginViewController: LoginViewController = LoginViewController(mode: .signUp)
            loginViewController.delegate = self
            self.navigationController.pushViewController(loginViewController, animated: true)
        } else {
            let loginViewController: LoginViewController = LoginViewController(mode: .signIn)
            loginViewController.delegate = self
            self.navigationController.pushViewController(loginViewController, animated: true)
        }
    }
    
    func setTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()

        let fileItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        let settingsItem = UITabBarItem(title: "Setings", image: UIImage(systemName: "gear"), tag: 1)
        
        let fileCoordinator = FileCoordinator()
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        fileCoordinator.openFileViewController(directoryURL: directoryURL!, title: "Documents")
        let fileViewController = fileCoordinator.navigationController
        fileViewController.tabBarItem = fileItem
        childCoordinators.append(fileCoordinator)

        let settingsCoordinator = SettingsCoordinator()
        settingsCoordinator.openSettingsViewController()
        let settingsViewController = settingsCoordinator.navigationController
        settingsViewController.tabBarItem = settingsItem
        childCoordinators.append(settingsCoordinator)
        
        tabBarController.viewControllers = [fileViewController, settingsViewController]
        
        return tabBarController
    }
}

protocol LoginViewControllerDelegate: AnyObject {
    func navigateToMainVC()
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func navigateToMainVC() {
        let tabBarController = self.setTabBarController()
        self.window?.rootViewController = tabBarController
    }
}
