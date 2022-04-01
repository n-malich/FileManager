//
//  LoginInspector.swift
//  FileManager
//
//  Created by Natali Malich
//

import Foundation
import KeychainAccess
import UIKit

class LoginInspector {
    
    static let shared = LoginInspector()
    let keychain = Keychain(service: "com.malich.FileManager")
    
    func signUp(password: String, completion: @escaping () -> Void) {
        keychain[password] = password
        completion()
        print("User registered")
        print("\(keychain.allKeys())")
    }
    
    func signIn(password: String, completion: @escaping (Bool) -> Void) {
        if keychain[password] != nil {
            completion(true)
            print("User logged in")
        } else {
            completion(false)
            print("User not logged in")
        }
        print("\(keychain.allKeys())")
    }
    
    func removePassword() {
        try! keychain.removeAll()
        print("\(keychain.allKeys())")
    }
}
