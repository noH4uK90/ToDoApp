//
//  URLSession.Extension.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/12/24.
//

import Foundation

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        var dataTask: URLSessionDataTask?
        
        return try await withTaskCancellationHandler {
            return try await withCheckedThrowingContinuation { continuation in
                dataTask = self.dataTask(with: urlRequest) { data, response, error in
                    if Task.isCancelled {
                        continuation.resume(throwing: CancellationError())
                    }
                    
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let data = data, let response = response {
                        continuation.resume(returning: (data, response))
                    } else {
                        continuation.resume(throwing: URLError(.badServerResponse))
                    }
                }
                
                if Task.isCancelled {
                    continuation.resume(throwing: CancellationError())
                }
                
                dataTask?.resume()
            }
        } onCancel: { [weak dataTask] in
            dataTask?.cancel()
        }
    }
}
