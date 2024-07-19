//
//  TodoItem.Extension.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/21/24.
//

import Foundation
import FileCacheLibrary
import UIKit

extension TodoItem {
    func modify(
        text: String? = nil,
        importance: Importance? = nil,
        expires: Date? = nil,
        isCompleted: Bool? = nil,
        createdDate: Date? = nil,
        changedDate: Date? = nil,
        color: String? = nil
    ) -> TodoItem {
        TodoItem(
            id: self.id,
            text: text ?? self.text,
            importance: importance ?? self.importance,
            expires: expires ?? self.expires,
            isCompleted: isCompleted ?? self.isCompleted,
            createdDate: createdDate ?? self.createdDate,
            changedDate: changedDate ?? changedDate,
            color: color ?? self.color
        )
    }
    
    func changeComplete() -> TodoItem {
        modify(isCompleted: !self.isCompleted)
    }
}

extension TodoItem {
    func toTodoItemNetwork() -> TodoItemNetwork {
        TodoItemNetwork(
            id: self.id,
            text: self.text,
            importance: self.importance.rawValue,
            deadline: self.expires?.toUnixTimestamp() ?? nil,
            done: self.isCompleted,
            color: self.color,
            createdAt: self.createdDate.toUnixTimestamp(),
            changedAt: self.changedDate?.toUnixTimestamp() ?? self.createdDate.toUnixTimestamp(),
            lastUpdatedBy: UIDevice.current.identifierForVendor!.uuidString
        )
    }
}

// MARK: Json parsing
extension TodoItem: JSONable {
    var json: Any {
        var todo: [String: Any] = [
            "id": id.isEmpty ? UUID().uuidString : id,
            "text": text,
            "isCompleted": isCompleted,
            "createdDate": createdDate.ISO8601Format()
        ]
        if importance != Importance.basic {
            todo["importance"] = importance.rawValue
        }
        
        if let expires = expires {
            todo["expires"] = expires.ISO8601Format()
        }
        
        if let changedDate = changedDate {
            todo["changedDate"] = changedDate.ISO8601Format()
        }
        
        if let color = color {
            todo["color"] = color
        }
        
        return todo
    }
    
    static func parse(json: Any) -> TodoItem? {
        guard let dictionary = json as? [String: Any] else {
            return nil
        }
        
        guard let id = dictionary["id"] as? String,
              let text = dictionary["text"] as? String,
              let isCompleted = dictionary["isCompleted"] as? Bool,
              let createdDateString = dictionary["createdDate"] as? String,
              let createdDate = ISO8601DateFormatter().date(from: createdDateString),
              !text.isEmpty else {
            return nil
        }
        
        let importanceString = dictionary["importance"] as? String
        let importance = Importance(rawValue: importanceString ?? "Обычная") ?? .basic
        
        var expires: Date? = nil
        if let expiresString = dictionary["expires"] as? String {
            expires = ISO8601DateFormatter().date(from: expiresString)
        }
        
        var changedDate: Date? = nil
        if let changedDateString = dictionary["changedDate"] as? String {
            changedDate = ISO8601DateFormatter().date(from: changedDateString)
        }
        
        let color = dictionary["color"] as? String
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            expires: expires,
            isCompleted: isCompleted,
            createdDate: createdDate,
            changedDate: changedDate,
            color: color
        )
    }
}

// MARK: CSV parsing
extension TodoItem: CSVable {
    
    static var fieldNames: [String] {
        ["id", "text", "importance", "expires", "isCompleted", "createdDate", "changedDate", "color"]
    }
    
    static func csvHeader(separator: Character = ";") -> String {
        fieldNames.joined(separator: String(separator))
    }
    
    var csv: (Character) -> String {
        { separator in
            var todo = [String](repeating: "", count: 8)
            
            todo[0] = id.isEmpty ? UUID().uuidString : id
            todo[1] = text.contains(separator) ? "\"\(text)\"" : text
            todo[2] = importance.rawValue
            todo[4] = String(isCompleted)
            todo[5] = createdDate.ISO8601Format()
            
            if let expires = expires {
                todo[3] = expires.ISO8601Format()
            }
            
            if let changedDate = changedDate {
                todo[6] = changedDate.ISO8601Format()
            }
            
            if let color = color {
                todo[7] = color
            }
            
            return todo.joined(separator: String(separator))
        }
    }
    
    static func parse(csv: String, separator: Character = ";") -> TodoItem? {
        if csv == csvHeader(separator: separator) {
            return nil
        }
        
        var todo: [String] = []
        var currentField = ""
        var quote = false
        
        for char in csv {
            if char == "\"" {
                quote.toggle()
            } else if char == separator && !quote {
                todo.append(currentField)
                currentField = ""
            } else {
                currentField.append(char)
            }
        }
        
        todo.append(currentField)
        
        let id = todo[0]
        let text = todo[1]
        let expires = ISO8601DateFormatter().date(from: todo[3])
        
        guard
            let importance = Importance(rawValue: todo[2]),
            let isCompleted = Bool(todo[4]),
            let createdDate = ISO8601DateFormatter().date(from: todo[5]),
            !text.isEmpty
        else {
            return nil
        }
        
        let changedDate = ISO8601DateFormatter().date(from: todo[6])
        let color = todo[7].isEmpty ? nil : todo[7]
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            expires: expires,
            isCompleted: isCompleted,
            createdDate: createdDate,
            changedDate: changedDate,
            color: color
        )
    }
}
