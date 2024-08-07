//
//  TodoItem.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/21/24.
//

import Foundation

struct TodoItem: Identifiable, Hashable {
    let id: String
    let text: String
    let importance: Importance
    let expires: Date?
    let isCompleted: Bool
    let createdDate: Date
    let changedDate: Date?
    let color: String?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance = .basic,
        expires: Date? = nil,
        isCompleted: Bool = false,
        createdDate: Date = Date(),
        changedDate: Date? = nil,
        color: String? = nil
    ) {
        self.id = id.isEmpty ? UUID().uuidString : id
        self.text = text
        self.importance = importance
        self.expires = expires
        self.isCompleted = isCompleted
        self.createdDate = createdDate
        self.changedDate = changedDate
        self.color = color
    }
}
