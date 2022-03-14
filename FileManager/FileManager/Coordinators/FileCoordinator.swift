//
//  FileCoordinator.swift
//  FileManager
//
//  Created by Natali Malich
//

import UIKit

class FileCoordinator: CoordinatorProtocol {
    
    weak var parentCoordinator: AppCoordinator?
    let navigationController: UINavigationController
    var childCoordinators = [CoordinatorProtocol]()
    
    required init() {
        self.navigationController = .init()
    }
    
    func openFileViewController() {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileViewController: FileViewController = FileViewController(data: File(name: "Documents", mode: .document, image: nil, url: documentURL.path, children: []))
        fileViewController.navigationItem.title = "Documents"
        self.navigationController.viewControllers = [fileViewController]
    }
}
