//
//  APIHeaders.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/19/24.
//

import Foundation

enum APIHeaders: String {
    case auth = "Authorization"
    case contentType = "Content-Type"
    case revision = "X-Last-Known-Revision"
    case fail = "X-Generate-Fails"
    
    func apply(value: String, headers: inout Headers) {
        headers[self.rawValue] = value
    }
}
