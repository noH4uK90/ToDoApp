//
//  DataTransferService.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/16/24.
//

import Foundation

typealias Headers = [String: String]

protocol NetworkProtocol {
    func performRequest(_ url: URL, method: HTTPMethods, headers: Headers?, attempts: Int) async throws
    func performRequest<TResult: Decodable>(_ url: URL, method: HTTPMethods, headers: [String: String]?, attempts: Int) async throws -> TResult
    
    func performRequestWithBody<TData: Encodable>(_ url: URL, _ body: TData, method: HTTPMethods, headers: [String: String]?, attempts: Int) async throws
    func performRequestWithBody<TData: Encodable, TResult: Decodable>(
        _ url: URL,
        _ body: TData,
        method: HTTPMethods,
        headers: [String: String]?,
        attempts: Int
    ) async throws -> TResult
}

final class NetworkService: NSObject, NetworkProtocol {
    
    private let minDelay: TimeInterval = 2
    private let maxDelay: TimeInterval = 120
    private let factor: Double = 1.5
    private let jitter: Double = 0.05
    private let maxAttempts: Int = 5
    
    func performRequest(_ url: URL, method: HTTPMethods, headers: Headers? = nil, attempts: Int = 0) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                Task {
                    do {
                        let request = try self.createRequest(url, method: method, headers: headers)
                        let (_, response) = try await self.session.data(for: request)
                        
                        try self.handleResponse(response)
                        continuation.resume()
                    } catch {
                        self.retryRequest(url: url, method: method, headers: headers, attempts: attempts + 1, continuation: continuation)
                    }
                }
            }
        }
    }
    
    func performRequest<TResult: Decodable>(_ url: URL, method: HTTPMethods, headers: Headers? = nil, attempts: Int = 0) async throws -> TResult {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                Task {
                    do {
                        let request = try self.createRequest(url, method: method, headers: headers)
                        print(Task.currentPriority)
                        let (data, response) = try await self.session.data(for: request)
                        print(Task.currentPriority)
                        
                        try self.handleResponse(response)
                        
                        let result = try JSONDecoder().decode(TResult.self, from: data)
                        continuation.resume(returning: result)
                    } catch {
                        self.retryRequest(url: url, method: method, headers: headers, attempts: attempts + 1, continuation: continuation)
                    }
                }
            }
        }
    }
    
    func performRequestWithBody<TData: Encodable>(_ url: URL, _ body: TData, method: HTTPMethods, headers: Headers? = nil, attempts: Int = 0) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                Task {
                    do {
                        let requestData = try JSONEncoder().encode(body)
                        let request = try self.createRequest(url, requestData, method: method, headers: headers)
                        let (_, response) = try await self.session.data(for: request)
                        
                        try self.handleResponse(response)
                        continuation.resume()
                    } catch {
                        self.retryRequest(url: url, body: body, method: method, headers: headers, attempts: attempts, continuation: continuation)
                    }
                }
            }
        }
    }
    
    func performRequestWithBody<TData: Encodable, TResult: Decodable>(_ url: URL, _ body: TData, method: HTTPMethods, headers: Headers? = nil, attempts: Int = 0) async throws -> TResult {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                Task {
                    do {
                        let requestData = try JSONEncoder().encode(body)
                        let request = try self.createRequest(url, requestData, method: method, headers: headers)
                        let (data, response) = try await self.session.data(for: request)
                        
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
    
    private lazy var session: URLSession = {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        return session
    }()
}

// MARK: Retry request
private extension NetworkService {
    private func retryRequest(url: URL, method: HTTPMethods, headers: Headers?, attempts: Int, continuation: CheckedContinuation<Void, Error>) {
        let delay = calculateDelay(attempts: attempts)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            Task {
                do {
                    try await self.performRequest(url, method: method, headers: headers)
                    continuation.resume()
                } catch {
                    if attempts < self.maxAttempts {
                        self.retryRequest(url: url, method: method, headers: headers, attempts: attempts + 1, continuation: continuation)
                    } else {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    private func retryRequest<TResult: Decodable>(url: URL, method: HTTPMethods, headers: Headers?, attempts: Int, continuation: CheckedContinuation<TResult, Error>) {
        let delay = calculateDelay(attempts: attempts)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            Task {
                do {
                    let result: TResult = try await self.performRequest(url, method: method, headers: headers, attempts: attempts)
                    continuation.resume(returning: result)
                } catch {
                    if attempts < self.maxAttempts {
                        self.retryRequest(url: url, method: method, headers: headers, attempts: attempts + 1, continuation: continuation)
                    } else {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    private func retryRequest<TData: Encodable>(url: URL, body: TData, method: HTTPMethods, headers: Headers?, attempts: Int, continuation: CheckedContinuation<Void, Error>) {
        let delay = calculateDelay(attempts: attempts)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            Task {
                do {
                    try await self.performRequestWithBody(url, body, method: method, headers: headers, attempts: attempts)
                    continuation.resume()
                } catch {
                    if attempts < self.maxAttempts {
                        self.retryRequest(url: url, body: body, method: method, headers: headers, attempts: attempts, continuation: continuation)
                    } else {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    private func calculateDelay(attempts: Int) -> Double {
        let delay = min(minDelay * pow(factor, Double(attempts)), maxDelay)
        return delay * (1 + (Double.random(in: -jitter...jitter)))
    }
}

// MARK: Creating request
private extension NetworkService {
    private func createRequest(_ url: URL, method: HTTPMethods, headers: [String: String]?) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        setDefaultHeaders(for: &request)
        if let headers = headers {
            addHeaders(for: &request, headers: headers)
        }
        
        return request
    }
    
    private func createRequest<T: Encodable>(_ url: URL, _ body: T, method: HTTPMethods, headers: [String: String]?) throws -> URLRequest {
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
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer Inglorion", forHTTPHeaderField: "Authorization")
    }
    
    private func addHeaders(for request: inout URLRequest, headers: [String: String]) {
        headers.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
    }
}

// MARK: Handling response
private extension NetworkService {
    private func handleResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 400...499:
            throw URLError(.badURL)
        case 500...599:
            throw URLError(.serverCertificateHasBadDate)
        default:
            throw URLError(.unknown)
        }
    }
}

extension NetworkService: URLSessionDelegate {
    nonisolated public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, urlCredential)
    }
}
