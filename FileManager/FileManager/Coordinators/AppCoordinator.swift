//
//  AppCoordinator.swift
//  FileManager
//
//  Created by Natali Malich
//

import UIKit

class AppCoordinator: CoordinatorProtocol {
    
    var childCoordinators = [CoordinatorProtocol]()
    let window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
        window?.makeKeyAndVisible()
    }

    func start() {
        let tabBarController = self.setTabBarController()
        self.window?.rootViewController = tabBarController
    }

    func setTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let firstCoordinator = LoginCoordinator(window: self.window)
        firstCoordinator.parentCoordinator = self
        firstCoordinator.openLoginViewController()
        let firstViewController = firstCoordinator.navigationController
        
        tabBarController.viewControllers = [firstViewController]
        
        return tabBarController
    }
}
