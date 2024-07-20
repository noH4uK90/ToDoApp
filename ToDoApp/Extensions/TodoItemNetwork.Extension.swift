//
//  TodoItemNetwork.Extension.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/20/24.
//

import Foundation

extension TodoItemNetwork {
    func toTodoItem() -> TodoItem {
        TodoItem(
            id: self.id,
            text: self.text,
            importance: Importance(rawValue: self.importance) ?? .basic,
            expires: self.deadline?.toDate() ?? nil,
            isCompleted: self.done,
            createdDate: self.createdAt.toDate(),
            changedDate: self.changedAt.toDate(),
            color: color
        )
    }
}
