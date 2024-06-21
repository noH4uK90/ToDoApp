//
//  TodoItem.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/21/24.
//

import Foundation

struct TodoItem: Identifiable {
    let id: String
    let text: String
    let importance: Importance
    let expires: Date?
    let isCompleted: Bool
    let createdDate: Date = Date()
    let changedDate: Date? = nil
    
    init(
        id: String? = nil,
        text: String,
        importance: Importance? = .usual,
        expires: Date? = nil,
        isCompleted: Bool? = false
    ) {
        self.id = id ?? UUID().uuidString
        self.text = text
        self.importance = importance ?? .usual
        self.expires = expires
        self.isCompleted = isCompleted ?? false
    }
}
