//
//  Config.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/16/24.
//

import Foundation

struct Config {
    enum Keys {
        static let baseURL = "BASE_URL"
    }
    
    static let baseURL: String = {
        guard let baseURLProperty = Bundle.main.object(forInfoDictionaryKey: Keys.baseURL) as? String else {
            fatalError("BASE_URL not found")
        }
        return baseURLProperty
    }()
}
