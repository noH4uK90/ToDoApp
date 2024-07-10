//
//  ToDoListViewModel.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/5/24.
//

import Foundation

@MainActor
class TodoListViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var completedCount: Int = 0
    @Published var selectedTodo: TodoItem? = nil
    
    init() {
        self.todos = [
            TodoItem(text: "Сделать что-то"),
            TodoItem(text: "Сделать что-то важное", importance: .important),
            TodoItem(text: "Сделать что-то неважное", importance: .unimportant, color: "705335")
        ]
        getCompletedCount()
    }
    
    func saveTodo(todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
        } else {
            todos.append(todo)
        }
    }
    
    func complete(id: String) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos[index] = todos[index].changeComplete()
            getCompletedCount()
        }
    }
    
    func delete(id: String) {
        todos.removeAll(where: { $0.id == id })
        getCompletedCount()
    }
    
    func getCompletedCount() {
        self.completedCount = todos.count(where: { $0.isCompleted })
    }
}
