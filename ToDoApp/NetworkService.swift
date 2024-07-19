//
//  DataTransferService.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/16/24.
//

import Foundation

typealias Headers = [String: String]

protocol NetworkProtocol: Sendable {
    var activeRequests: Int { get }
    var activeRequestsPublished: Published<Int> { get }
    var activeRequestsPublisher: Published<Int>.Publisher { get }
    
    func performRequest<TResult: Sendable & Decodable>(_ url: URL, method: HTTPMethods, headers: Headers?) async throws -> TResult
    
    func performRequestWithBody<TData: Sendable & Encodable, TResult: Sendable & Decodable>(_ url: URL, _ body: TData, method: HTTPMethods, headers: Headers?) async throws -> TResult
    
    func retry<T: Sendable & Decodable>(maxAttempts: Int, operation: @escaping () async throws -> T, onCancel: @escaping () async throws -> T) async rethrows -> T
}

extension NetworkProtocol {
    func performRequest<TResult: Sendable & Decodable>(_ url: URL, method: HTTPMethods, headers: Headers? = nil) async throws -> TResult {
        try await performRequest(url, method: method, headers: headers)
    }
    
    func performRequestWithBody<TData: Sendable & Encodable, TResult: Sendable & Decodable>(_ url: URL, _ body: TData, method: HTTPMethods, headers: Headers? = nil) async throws -> TResult {
        try await performRequestWithBody(url, body, method: method, headers: headers)
    }
}

final class NetworkService: NSObject, NetworkProtocol, Sendable {
    @Published var activeRequests: Int = 0
    var activeRequestsPublished: Published<Int> { _activeRequests }
    var activeRequestsPublisher: Published<Int>.Publisher { $activeRequests }
    
    private let minDelay: TimeInterval = 2
    private let maxDelay: TimeInterval = 120
    private let factor: Double = 1.5
    private let jitter: Double = 0.05
    private let maxAttempts: Int = 5
    
    @discardableResult
    func performRequest<TResult: Sendable & Decodable>(
        _ url: URL,
        method: HTTPMethods,
        headers: Headers? = nil
    ) async throws -> TResult {
        activeRequests += 1
        defer { activeRequests -= 1 }
        
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                Task {
                    do {
                        let request = try self.createRequest(url, method: method, headers: headers)
                        let (data, response) = try await URLSession.shared.data(for: request)
                        
//                        try await Task.sleep(nanoseconds: 2_000_000_000)
                        
                        try self.handleResponse(response)
                        
                        let result = try JSONDecoder().decode(TResult.self, from: data)
                        continuation.resume(returning: result)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    @discardableResult
    func performRequestWithBody<TData: Sendable & Encodable, TResult: Sendable & Decodable>(
        _ url: URL,
        _ body: TData,
        method: HTTPMethods,
        headers: Headers? = nil
    ) async throws -> TResult {
        activeRequests += 1
        defer { activeRequests -= 1}
        
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                Task {
                    do {
                        let request = try self.createRequest(url, body, method: method, headers: headers)
                        let (data, response) = try await URLSession.shared.data(for: request)
                        
                        try self.handleResponse(response)
                        
                        let result = try JSONDecoder().decode(TResult.self, from: data)
                        continuation.resume(returning: result)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    func retry<T: Sendable & Decodable>(maxAttempts: Int, operation: @escaping () async throws -> T, onCancel: @escaping () async throws -> T) async rethrows -> T {
        var attempts = 0
        while attempts < maxAttempts {
            do {
                return try await operation()
            } catch {
                attempts += 1
                if attempts < maxAttempts {
                    let delay = calculateDelay(attempts: attempts)
                    let delayInNanoseconds = UInt64(delay * 1_000_000_000)
                    try await Task.sleep(nanoseconds: delayInNanoseconds)
                }
            }
        }
        
        return try await onCancel()
    }
}

// MARK: Retry request
private extension NetworkService {
    private func calculateDelay(attempts: Int) -> Double {
        let delay = min(minDelay * pow(factor, Double(attempts)), maxDelay)
        return delay * (1 + (Double.random(in: -jitter...jitter)))
    }
}

// MARK: Creating request
private extension NetworkService {
    private func createRequest(_ url: URL, method: HTTPMethods, headers: Headers?) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        setDefaultHeaders(for: &request)
        if let headers = headers {
            addHeaders(for: &request, headers: headers)
        }
        
        return request
    }
    
    private func createRequest<T: Encodable>(_ url: URL, _ body: T, method: HTTPMethods, headers: Headers?) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        setDefaultHeaders(for: &request)
        if let headers = headers {
            addHeaders(for: &request, headers: headers)
        }
        request.httpBody = try JSONEncoder().encode(body)
        
        return request
    }
    
    private func setDefaultHeaders(for request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: APIHeaders.contentType.rawValue)
        request.setValue("Bearer Inglorion", forHTTPHeaderField: APIHeaders.auth.rawValue)
    }
    
    private func addHeaders(for request: inout URLRequest, headers: Headers) {
        headers.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
    }
}

// MARK: Handling response
private extension NetworkService {
    private func handleResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.badResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError
        default:
            throw NetworkError.unknownError
        }
    }
}
