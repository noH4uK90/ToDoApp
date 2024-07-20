//
//  API.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/16/24.
//

import Foundation

enum API {
    static func getComponents(for url: APIUrls = .baseURL, with path: String, scheme: APIScheme = .https) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme.rawValue
        urlComponents.host = url.localizedURL
        urlComponents.path = path
        
        return urlComponents
    }
}
