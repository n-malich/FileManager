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

        let firstItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)


        let firstCoordinator = FileCoordinator()
        firstCoordinator.parentCoordinator = self
        firstCoordinator.openFileViewController()
        let firstViewController = firstCoordinator.navigationController
        firstViewController.tabBarItem = firstItem

        tabBarController.viewControllers = [firstViewController]

        return tabBarController
    }
}
