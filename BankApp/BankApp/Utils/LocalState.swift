//
//  LocalState.swift
//  BankApp
//
//  Created by Alex on 27/11/2022.
//

import Foundation

class LocalState {
    private enum Keys: String {
        case hasOnboarded
    }
    
    public static var hasOnboarded: Bool {
        get {
            return UserDefaults.standard.bool(forKey:Keys.hasOnboarded.rawValue)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.hasOnboarded.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}
