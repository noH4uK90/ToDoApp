//
//  TodoActor.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/20/24.
//

import Foundation
import Combine

actor TodoNetworkActor {
    private(set) var todos: [TodoItem] = []
    private var isDirty: Bool = false
    @Published var activeRequests: Int = 0
    @Inject private var todoNetworkService: TodoNetworkProtocol
    private var bag = Set<AnyCancellable>()
    
    init() {
        todoNetworkService.activeRequestsPublisher
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] value in
                    Task {
                        await self?.changeRequests(value: value)
                    }
                }
            )
            .store(in: &bag)
    }
    
    func changeRequests(value: Int) {
        self.activeRequests = value
    }
    
    func fetchTodos() async throws {
        do {
            let response = try await todoNetworkService.getTodos()
            todos = response.list.map({ $0.toTodoItem() })
            isDirty = false
        } catch {
            throw error
        }
    }
    
    func addTodo(todo: TodoItem) async throws {
        do {
            let networkTodo = todo.toTodoItemNetwork()
            let response = try await todoNetworkService.postTodo(todo: networkTodo)
            let todoItem = response.element.toTodoItem()
            todos.append(todoItem)
        } catch {
            isDirty = true
            try await fetchTodos()
        }
    }
    
    func updateTodo(id: String, todo: TodoItem) async throws {
        do {
            let networkTodo = todo.toTodoItemNetwork()
            let response = try await todoNetworkService.putTodo(id: id, todo: networkTodo)
            let todoItem = response.element.toTodoItem()
            if let index = todos.firstIndex(where: { $0.id == id }) {
                todos[index] = todoItem
            } else {
                todos.append(todoItem)
            }
        } catch {
            isDirty = true
            try await fetchTodos()
        }
    }
    
    func updateTodos(todos: [TodoItem]) async throws {
        do {
            let networkTodos = todos.map({ $0.toTodoItemNetwork() })
            let response = try await todoNetworkService.patchTodos(todos: networkTodos)
            self.todos = response.list.map({ $0.toTodoItem() })
        } catch {
            isDirty = true
            try await fetchTodos()
        }
    }
}
