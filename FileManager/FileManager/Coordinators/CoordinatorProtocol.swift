//
//  CoordinatorProtocol.swift
//  FileManager
//
//  Created by Natali Malich
//

import Foundation

public protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] {get set}
}
