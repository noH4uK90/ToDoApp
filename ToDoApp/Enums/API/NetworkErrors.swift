//
//  APIErrors.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/19/24.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case badResponse
    case unauthorized
    case notFound
    case serverError
    case invalidURL
    case unknownError
    
    var localizedDescription: String {
        switch self {
            case .badRequest:
                "Bad request"
            case .badResponse:
                "Bad response"
            case .unauthorized:
                "Not authorized"
            case .notFound:
                "Not found"
            case .serverError:
                "Server error"
            case .invalidURL:
                "Invalid URL"
            case .unknownError:
                "Unknown error"
        }
    }
}
