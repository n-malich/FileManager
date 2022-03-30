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
    private let keychain = Keychain(service: "com.malich.FileManager")
    
    func signUp(password: String, completion: @escaping () -> Void) {
        if keychain.allKeys().isEmpty {
            keychain[password] = password
            completion()
            UserDefaults.standard.set(false, forKey: "Password")
            print("Пароль сохранен. Пользователь вошел")
        } else {
            print("Ошибка. Пароль не сохранен")
        }
        print("\(keychain.allKeys())")
    }
    
    func signIn(password: String, completion: @escaping (Bool) -> Void) {
        if !keychain.allKeys().isEmpty, keychain[password] != nil {
            completion(true)
            UserDefaults.standard.set(true, forKey: "Password")
            print("Пользователь вошел")
        } else {
            completion(false)
            print("Пользователь не вошел")
        }
        print("\(keychain.allKeys())")
    }
    
    func removePassword() {
        try! keychain.removeAll()
        print("\(keychain.allKeys())")
    }
}
