//
//  FileManager.swift
//  FileManager
//
//  Created by Natali Malich
//

import Foundation
import UIKit

enum Mode {
    case document
    case image
}

class File {

    var name: String
    var mode: Mode
    var image: UIImage?
    var url: String
    var children: [File]

    init(name: String, mode: Mode, image: UIImage?, url: String, children: [File]) {
        self.name = name
        self.mode = mode
        self.image = image
        self.url = url
        self.children = children
    }
}

class FileManagerApp {

    static let shared = FileManagerApp()
    private let fileManager = FileManager.default

    func createFolder(nameFolder: String, mode: Mode) -> File {
        let folderURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let url = folderURL!.appendingPathComponent(nameFolder)
        do {
            try fileManager.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: [:])
        } catch {
            print("Error")
        }
        
        let newFile = File(name: nameFolder, mode: .document, image: UIImage(systemName: "folder.fill"), url: url.path, children: [])
        return newFile
    }
    
    func createImage(nameImage: String, mode: Mode, image: UIImage) -> File {
        let folderURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let url = folderURL!.appendingPathComponent(nameImage)
        fileManager.createFile(atPath: url.path, contents: image.jpegData(compressionQuality: 0), attributes: [:])
        
        let newImage = File(name: nameImage, mode: .image, image: image, url: url.path, children: [])
        return newImage
    }
    
    func deleteFile(directoryPath: String, filePath: String) {
        if fileManager.fileExists(atPath: directoryPath) {
            do {
                try fileManager.removeItem(atPath: filePath)
            } catch {
                print("Could not delete file, probably read-only filesystem")
            }
        }
    }
}
