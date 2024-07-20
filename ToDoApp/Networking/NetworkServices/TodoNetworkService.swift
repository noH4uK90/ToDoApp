//
//  TodoNetworkService.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/16/24.
//

import Foundation
import Combine

protocol TodoNetworkProtocol {
    var activeRequests: Int { get }
    var activeRequestsPublished: Published<Int> { get }
    var activeRequestsPublisher: Published<Int>.Publisher { get }
    
    func getTodos() async throws -> ListResponse<TodoItemNetwork>
    func patchTodos(todos: [TodoItemNetwork]) async throws -> ListResponse<TodoItemNetwork>
    func getTodo(id: String) async throws -> ElementResponse<TodoItemNetwork>
    func postTodo(todo: TodoItemNetwork) async throws -> ElementResponse<TodoItemNetwork>
    func putTodo(id: String, todo: TodoItemNetwork) async throws -> ElementResponse<TodoItemNetwork>
    func deleteTodo(id: String) async throws -> ElementResponse<TodoItemNetwork>
}

final class TodoNetworkService: TodoNetworkProtocol {
    @Published var activeRequests: Int = 0
    var activeRequestsPublished: Published<Int> { _activeRequests }
    var activeRequestsPublisher: Published<Int>.Publisher { $activeRequests }
    
    @Inject private var network: NetworkProtocol
    private var bag = Set<AnyCancellable>()
    
    init() {
        network.activeRequestsPublisher
            .receive(on: RunLoop.current)
            .sink(receiveValue: { [weak self] _ in
                self?.activeRequests = self?.network.activeRequests ?? 0
            })
            .store(in: &bag)
    }
    
    func getTodos() async throws -> ListResponse<TodoItemNetwork> {
        guard let url = TodoEndpoints.todos.absoluteURL else {
            throw NetworkError.invalidURL
        }
        
//        return try await network.performRequest(url, method: .get)
        return try await network.retry(maxAttempts: 5, operation: {
            let response: ListResponse<TodoItemNetwork> = try await self.network.performRequest(url, method: .get)
            UserDefaults.standard.setValue(response.revision, forKey: "revision")
            return response
        }, onCancel: {
            throw NetworkError.unknownError
        })
    }
    
    func patchTodos(todos: [TodoItemNetwork]) async throws -> ListResponse<TodoItemNetwork> {
        guard let url = TodoEndpoints.todos.absoluteURL else {
            throw NetworkError.invalidURL
        }
        
        let revision = UserDefaults.standard.integer(forKey: "revision")
        var headers: Headers = [:]
        APIHeaders.revision.apply(value: "\(revision)", headers: &headers)
        
        return try await network.retry(maxAttempts: 5) {
            return try await self.network.performRequestWithBody(url, ListRequest(list: todos), method: .patch, headers: headers)
        } onCancel: {
            return try await self.network.performRequest(url, method: .get)
        }
    }
    
    func getTodo(id: String) async throws -> ElementResponse<TodoItemNetwork> {
        guard let url = TodoEndpoints.todo(id: id).absoluteURL else {
            throw NetworkError.invalidURL
        }
        
        return try await network.performRequest(url, method: .get)
    }
    
    func postTodo(todo: TodoItemNetwork) async throws -> ElementResponse<TodoItemNetwork> {
        guard let url = TodoEndpoints.todos.absoluteURL else {
            throw NetworkError.invalidURL
        }
        
        let revision = UserDefaults.standard.integer(forKey: "revision")
        var headers: Headers = [:]
        APIHeaders.revision.apply(value: "\(revision)", headers: &headers)
        
        return try await network.performRequestWithBody(url, ElementRequest(element: todo), method: .post, headers: headers)
    }
    
    func putTodo(id: String, todo: TodoItemNetwork) async throws -> ElementResponse<TodoItemNetwork> {
        guard let url = TodoEndpoints.todo(id: id).absoluteURL else {
            throw NetworkError.invalidURL
        }
        
        let revision = UserDefaults.standard.integer(forKey: "revision")
        var headers: Headers = [:]
        APIHeaders.revision.apply(value: "\(revision)", headers: &headers)
        
        return try await network.retry(maxAttempts: 5) {
            return try await self.network.performRequestWithBody(url, ElementRequest(element: todo), method: .put, headers: headers)
        } onCancel: {
            return try await self.network.performRequest(url, method: .get)
        }
    }
    
    func deleteTodo(id: String) async throws -> ElementResponse<TodoItemNetwork> {
        guard let url = TodoEndpoints.todo(id: id).absoluteURL else {
            throw NetworkError.invalidURL
        }
        
        return try await network.performRequest(url, method: .delete)
    }
}
