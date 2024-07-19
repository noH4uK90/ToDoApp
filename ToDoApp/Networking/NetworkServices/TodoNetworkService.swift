//
//  TodoNetworkService.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/16/24.
//

import Foundation

protocol TodoNetworkProtocol {
    func getTodos() async throws -> ListResponse<TodoItemNetwork>
    func patchTodos() async throws -> ListResponse<TodoItemNetwork>
    func getTodo(id: UUID) async throws -> ElementResponse<TodoItemNetwork>
    func postTodo(todos: [TodoItemNetwork]) async throws -> ElementResponse<TodoItemNetwork>
    func putTodo(id: UUID, todo: TodoItemNetwork) async throws -> ElementResponse<TodoItemNetwork>
}

final class TodoNetworkService: TodoNetworkProtocol {
    @Inject private var network: NetworkProtocol
    
    func getTodos() async throws -> ListResponse<TodoItemNetwork> {
        guard let url = TodoEndpoints.todos.absoluteURL else {
            throw URLError(.badURL)
        }
        
        return try await network.performRequest(url, method: .get, headers: nil, attempts: 0)
    }
    
    func patchTodos() async throws -> ListResponse<TodoItemNetwork> {
        guard let url = TodoEndpoints.todos.absoluteURL else {
            throw URLError(.badURL)
        }
        
        return try await network.performRequest(url, method: .patch, headers: nil, attempts: 0)
    }
    
    func getTodo(id: UUID) async throws -> ElementResponse<TodoItemNetwork> {
        guard let url = TodoEndpoints.todo(id: id.uuidString).absoluteURL else {
            throw URLError(.badURL)
        }
        
        return try await network.performRequest(url, method: .get, headers: nil, attempts: 0)
    }
    
    func postTodo(todos: [TodoItemNetwork]) async throws -> ElementResponse<TodoItemNetwork> {
        guard let url = TodoEndpoints.todos.absoluteURL else {
            throw URLError(.badURL)
        }
        
        return try await network.performRequestWithBody(url, todos, method: .post, headers: nil, attempts: 0)
    }
    
    func putTodo(id: UUID, todo: TodoItemNetwork) async throws -> ElementResponse<TodoItemNetwork> {
        guard let url = TodoEndpoints.todo(id: id.uuidString).absoluteURL else {
            throw URLError(.badURL)
        }
        
        return try await network.performRequestWithBody(url, todo, method: .put, headers: nil, attempts: 0)
    }
    
    func deleteTodo(id: UUID) async throws -> ElementResponse<TodoItemNetwork> {
        guard let url = TodoEndpoints.todo(id: id.uuidString).absoluteURL else {
            throw URLError(.badURL)
        }
        
        return try await network.performRequest(url, method: .delete, headers: nil, attempts: 0)
    }
}
