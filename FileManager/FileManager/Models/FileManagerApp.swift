//
//  FileManagerApp.swift
//  FileManager
//
//  Created by Natali Malich
//

import Foundation
import UIKit

class FileManagerApp {

    static let shared = FileManagerApp()
    private let fileManager = FileManager.default
  
    func showFile(directoryURL: URL) -> [URL]? {
        var listFiles = [URL]()
        let contents = try! fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
        
        for file in contents {
            listFiles.append(file)
        }
        return listFiles
    }
    
    func createFolder(nameFolder: String, directoryURL: URL) {
        let url = directoryURL.appendingPathComponent(nameFolder)
        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: [:])
        } catch {
            print("Error")
        }
    }
    
    func createImage(nameImage: String, directoryURL: URL, data: Data) {
        let url = directoryURL.appendingPathComponent(nameImage)
        fileManager.createFile(atPath: url.path, contents: data, attributes: [:])
    }
    
    func deleteFile(directoryURL: URL, fileURL: URL) {
        if fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.removeItem(atPath: fileURL.path)
            } catch {
                print("Could not delete file, probably read-only filesystem")
            }
        }
    }
}
