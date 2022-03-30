//
//  Extensions.swift
//  FileManager
//
//  Created by Natali Malich
//

import UIKit

extension URL {
    var isDirectory: Bool {
       (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
