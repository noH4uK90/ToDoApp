//
//  TodoItem.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/21/24.
//

import Foundation

struct TodoItem: Identifiable, Hashable {
    let id: String
    var text: String
    var importance: Importance
    var expires: Date?
    var isCompleted: Bool
    let createdDate: Date
    let changedDate: Date?
    var color: String?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance = .usual,
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
    
    mutating func complete() {
        self.isCompleted.toggle()
    }
    
    mutating func modify(text: String, importance: Importance, expires: Date? = nil, color: String? = nil) {
        self.text = text
        self.importance = importance
        self.expires = expires
        self.color = color
    }
}
