//
//  FileCache.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/21/24.
//

import Foundation

class FileCache {
    private(set) var todos: [TodoItem] = []
    
    func createTodo(_ todo: TodoItem?) {
        guard let todo = todo else {
            return
        }
        
        if todos.first(where: { $0.id == todo.id }) != nil {
            return
        }
        
        todos.append(todo)
    }
    
    func deleteTodo(_ id: String) {
        todos.removeAll(where: { $0.id == id })
    }
    
    func saveToFile(to fileName: String = "todos.json") {
        do {
            let path = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(fileName)
            let jsonData = try JSONSerialization.data(withJSONObject: todos.map({ $0.json }), options: [])
            try jsonData.write(to: path)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func exportFromFile(from fileName: String = "todos.json") {
        do {
            let path = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(fileName)
            let data = try Data(contentsOf: path)
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                for json in jsonArray {
                    createTodo(TodoItem.parse(json: json))
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
}
