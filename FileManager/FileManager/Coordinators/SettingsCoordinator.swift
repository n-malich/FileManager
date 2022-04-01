//
//  SettingsCoordinator.swift
//  FileManager
//
//  Created by Natali Malich
//

import UIKit

class SettingsCoordinator: CoordinatorProtocol {
    
    weak var parentCoordinator: AppCoordinator?
    let navigationController: UINavigationController
    var childCoordinators = [CoordinatorProtocol]()
    
    required init() {
        self.navigationController = .init()
    }
    
    func openSettingsViewController() {
        let settingsViewController: SettingsViewController = SettingsViewController()
        settingsViewController.navigationItem.title = "Settings"
        settingsViewController.delegate = self
        self.navigationController.viewControllers = [settingsViewController]
    }
}

protocol SettingsViewControllerDelegate: AnyObject {
    func navigateToLoginVC()
}

extension SettingsCoordinator: SettingsViewControllerDelegate {
    func navigateToLoginVC() {
        let loginViewController: LoginViewController = LoginViewController(mode: .changePass)
        self.navigationController.present(loginViewController, animated: true, completion: nil)
    }
}
