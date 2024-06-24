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
    let createdDate: Date
    let changedDate: Date?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance = .usual,
        expires: Date? = nil,
        isCompleted: Bool = false,
        createdDate: Date = Date(),
        changedDate: Date? = nil
    ) {
        self.id = id.isEmpty ? UUID().uuidString : id
        self.text = text
        self.importance = importance
        self.expires = expires
        self.isCompleted = isCompleted
        self.createdDate = createdDate
        self.changedDate = changedDate
    }
}
