//
//  APIUrls.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/16/24.
//

import Foundation

enum APIUrls: String {
    case baseURL
    
    var localizedURL: String {
        switch self {
        case .baseURL:
            Config.baseURL
        }
    }
}
