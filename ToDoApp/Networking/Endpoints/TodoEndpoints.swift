//
//  TodoEndpoints.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/16/24.
//

import Foundation

enum TodoEndpoints {
    case todos
    case todo(id: String)
    
    func path() -> String {
        switch self {
        case .todos:
            "/"
        case .todo(let id):
            "/\(id)"
        }
    }
    
    var absoluteURL: URL? {
        var urlComponents = API.getComponents(with: APITags.todo.rawValue.appending(self.path()))
        
        switch self {
        case .todos:
            urlComponents.queryItems = []
        case .todo(let id):
            urlComponents.queryItems = [
                URLQueryItem(name: "id", value: id)
            ]
        }
        
        return urlComponents.url
    }
}
