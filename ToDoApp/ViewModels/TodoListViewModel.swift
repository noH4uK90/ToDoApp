//
//  ToDoListViewModel.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/5/24.
//

import Foundation
import FileCacheLibrary
import Combine

@MainActor
class TodoListViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var completedCount: Int = 0
    @Published var selectedTodo: TodoItem? = nil
    @Published var isActive: Bool = false
    
    @Inject private var todoNetworkService: TodoNetworkProtocol
    private let todoActor = TodoNetworkActor()
    private var bag = Set<AnyCancellable>()
    
    init() {
        do {
            Task {
                await todoActor.$activeRequests
                    .receive(on: RunLoop.current)
                    .sink(
                        receiveCompletion: { _ in },
                        receiveValue: { [weak self] value in
                            self?.isActive = value > 0
                        }
                    )
                    .store(in: &bag)
            }
            self.getTodosFromNetwork()
            self.getCompletedCount()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func saveTodo(todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
//            todos[index] = todo
            updateTodo(id: todo.id, todo: todo)
        } else {
//            todos.append(todo)
            createTodo(todo: todo)
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
    
    func getTodosFromNetwork() {
        Task {
            do {
                try await todoActor.fetchTodos()
                self.todos = await todoActor.todos
            } catch {
                print("Network error: \(error)")
            }
        }
    }
    
    func createTodo(todo: TodoItem) {
        Task {
            do {
                try await todoActor.addTodo(todo: todo)
                try await todoActor.fetchTodos()
                self.todos = await todoActor.todos
            } catch {
                print(error)
            }
        }
    }
    
    func updateTodo(id: String, todo: TodoItem) {
        Task {
            do {
                try await todoActor.updateTodo(id: id, todo: todo)
                try await todoActor.fetchTodos()
                self.todos = await todoActor.todos
            } catch {
                print(error)
            }
        }
    }
}
