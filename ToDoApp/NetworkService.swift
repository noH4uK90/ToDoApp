//
//  DataTransferService.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/16/24.
//

import Foundation

protocol NetworkProtocol {
    func performRequest(_ url: URL, method: HTTPMethods) async throws
    func performRequest<TResult: Decodable>(_ url: URL, method: HTTPMethods) async throws -> TResult
    
    func performRequest<TData: Encodable>(_ url: URL, _ body: TData, method: HTTPMethods) async throws
    func performRequest<TData: Encodable, TResult: Decodable>(_ url: URL, _ body: TData, method: HTTPMethods) async throws -> TResult
}

final class NetworkService: NetworkProtocol {
    
    func performRequest(_ url: URL, method: HTTPMethods) async throws {
        let request = try createRequest(url, method: method)
        let (_, response) = try await URLSession.shared.data(for: request)
        
        try handleResponse(response)
    }
    
    func performRequest<TResult: Decodable>(_ url: URL, method: HTTPMethods) async throws -> TResult {
        let request = try createRequest(url, method: method)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try handleResponse(response)
        
        return try JSONDecoder().decode(TResult.self, from: data)
    }
    
    func performRequest<TData: Encodable>(_ url: URL, _ body: TData, method: HTTPMethods) async throws {
        let requestData = try JSONEncoder().encode(body)
        let request = try createRequest(url, requestData, method: method)
        let (_, response) = try await URLSession.shared.data(for: request)
        
        try handleResponse(response)
    }
    
    func performRequest<TData: Encodable, TResult: Decodable>(_ url: URL, _ body: TData, method: HTTPMethods) async throws -> TResult {
        let requestData = try JSONEncoder().encode(body)
        let request = try createRequest(url, requestData, method: method)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try handleResponse(response)
        
        return try JSONDecoder().decode(TResult.self, from: data)
    }
}

private extension NetworkService {
    private func createRequest(_ url: URL, method: HTTPMethods) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        setDefaultHeaders(for: &request)
        
        return request
    }
    
    private func createRequest<T: Encodable>(_ url: URL, _ body: T, method: HTTPMethods) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        setDefaultHeaders(for: &request)
        request.httpBody = try JSONEncoder().encode(body)
        
        return request
    }
    
    private func setDefaultHeaders(for request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer Inglorion", forHTTPHeaderField: "Authorize")
    }
}

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
