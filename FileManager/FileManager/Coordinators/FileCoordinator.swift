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
    
    func openFileViewController(directoryURL: URL, title: String) {
        let fileViewController: FileViewController = FileViewController(url: directoryURL)
        fileViewController.delegate = self
        fileViewController.navigationItem.title = title
        self.navigationController.pushViewController(fileViewController, animated: true)
    }
}

protocol FileViewControllerDelegate: AnyObject {
    func navigateToImageVC(imageView: UIImage)
    func openFileViewController(directoryURL: URL, title: String)
}

extension FileCoordinator: FileViewControllerDelegate {
    func navigateToImageVC(imageView: UIImage) {
        let imageViewController: ImageViewController = ImageViewController(imageView: imageView)
        self.navigationController.present(imageViewController, animated: true, completion: nil)
    }
}
