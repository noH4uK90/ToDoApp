//
//  TodoItemNetwork.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/16/24.
//

import Foundation

struct TodoItemNetwork: Identifiable, Codable {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Int64
    let done: Bool
    let color: String
    let createdAt: Int64
    let changedAt: Int64
    let lastUpdatedBy: String
    
    enum CodingKeys: String, CodingKey {
        case id, text, importance, deadline, done, color
        case createdAt = "created_at"
        case changedAt = "changed_at"
        case lastUpdatedBy = "last_updated_by"
    }
}
