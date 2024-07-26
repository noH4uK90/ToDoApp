//
//  TodoItem.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/27/24.
//

import Foundation
import SwiftData

@Model
final class TodoItemDb {
    @Attribute(.unique)
    var id: UUID
    var text: String
    var importance: Importance
    var expires: Date?
    var isCompleted: Bool
    var createdDate: Date
    var changedDate: Date?
    var color: String?
    
    init(
        id: UUID = UUID(),
        text: String,
        importance: Importance = .basic,
        expires: Date? = nil,
        isCompleted: Bool = false,
        createdDate: Date = Date(),
        changedDate: Date? = nil,
        color: String? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.expires = expires
        self.isCompleted = isCompleted
        self.createdDate = createdDate
        self.changedDate = changedDate
        self.color = color
    }
}
