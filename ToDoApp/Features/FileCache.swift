//
//  FileCache.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/21/24.
//

import Foundation

final class FileCache {
    private let fileManager = FileManager.default
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
    
    func saveToFile(to fileName: String = "todos", extension fileExtension: FileExtension = .json, _ separator: Character = ";") {
        do {
            let path = getFileURL(fileName: fileName, fileExtension: fileExtension)
            switch fileExtension {
            case .json:
                try saveJSON(to: path)
            case .csv:
                try saveCSV(to: path, separator)
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    func exportFromFile(from fileName: String = "todos", extension fileExtension: FileExtension = .json, _ separator: Character = ";") {
        do {
            let path = getFileURL(fileName: fileName, fileExtension: fileExtension)
            switch fileExtension {
            case .json:
                try exportJSON(from: path)
            case .csv:
                try exportCSV(from: path, separator)
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    func removeAll() {
        todos = []
    }
    
    private func getFileURL(fileName: String, fileExtension: FileExtension) -> URL {
        fileManager
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileExtension.rawValue)
    }
}

// MARK: Extension for work with JSON
extension FileCache {
    private func saveJSON(to path: URL) throws {
        let jsonData = try JSONSerialization.data(withJSONObject: todos.map({ $0.json }), options: [])
        try jsonData.write(to: path)
    }
    
    private func exportJSON(from path: URL) throws {
        let data = try Data(contentsOf: path)
        if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
            for json in jsonArray {
                createTodo(TodoItem.parse(json: json))
            }
        }
    }
}

// MARK: Extension for work with CSV
extension FileCache {
    private func saveCSV(to path: URL, _ separator: Character) throws {
        var csv: [String] = [TodoItem.csvHeader(separator: separator)]
        
        todos.forEach { todo in
            csv.append(todo.csv(separator))
        }
        
        let csvString = csv.joined(separator: "\n")
        try csvString.write(to: path, atomically: false, encoding: .utf8)
    }
    
    private func exportCSV(from path: URL, _ separator: Character) throws {
        let csvString = try String(contentsOf: path, encoding: .utf8)
        let todos = csvString.split(separator: "\n").map({ String($0) })
        todos.forEach { todo in
            createTodo(TodoItem.parseCSV(from: todo))
        }
    }
}
