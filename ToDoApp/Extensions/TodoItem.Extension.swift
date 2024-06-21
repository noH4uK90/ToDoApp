//
//  TodoItem.Extension.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/21/24.
//

import Foundation

extension TodoItem {
    var json: Any {
        var todo: [String: Any] = [
            "id": id,
            "text": text,
            "isCompleted": isCompleted
        ]
        if importance != Importance.usual {
            todo["importance"] = importance.rawValue
        }
        
        if let expires = expires {
            todo["expires"] = expires.ISO8601Format()
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
              !text.isEmpty else {
            return nil
        }
        
        let importanceString = dictionary["importance"] as? String
        let importance = Importance(rawValue: importanceString ?? "Обычная") ?? .usual
        
        var expires: Date? = nil
        if let expiresString = dictionary["expires"] as? String {
            expires = ISO8601DateFormatter().date(from: expiresString)
        }
        
        return TodoItem(id: id, text: text, importance: importance, expires: expires, isCompleted: isCompleted)
    }
    
    static func parseCSV(from csv: String, separator: Character = ";") -> [TodoItem] {
        var result: [TodoItem] = []
        let csvStrings = csv.split(separator: "\n").map({ String($0) })
        
        for csvString in csvStrings {
            var todo: [String] = []
            var currentField = ""
            var quote = false
            
            for char in csvString {
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
            let isCompleted = Bool(todo[2])
            let importance = Importance(rawValue: todo[3])
            let expires = ISO8601DateFormatter().date(from: todo[4])
            
            if text.isEmpty {
                continue
            }
            
            let parsedTodo = TodoItem(
                id: id.isEmpty ? nil : id,
                text: text,
                importance: importance,
                expires: expires,
                isCompleted: isCompleted
            )
            result.append(parsedTodo)
        }
        
        return result
    }
}
