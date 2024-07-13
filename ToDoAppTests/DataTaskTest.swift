//
//  DataTaskTest.swift
//  ToDoAppTests
//
//  Created by Иван Спирин on 7/13/24.
//

import Foundation
import XCTest
@testable import ToDoApp

class DataTaskTest: XCTestCase {
    func testDataTaskSuccess() async {
        guard let url = URL(string: "https://ya.ru") else {
            XCTFail("Invalid URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let expectation = XCTestExpectation(description: "Task should succeed")
        
        let task = Task {
            do {
                let (data, response) = try await URLSession.shared.data(for: urlRequest)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected HTTP status code 200, but got \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                }
            } catch {
                XCTFail("Expected success, but got error: \(error)")
            }
        }
        
        await fulfillment(of: [expectation], timeout: 10)
    }
    
    func testDataTaskNetworkError() async {
        let urlRequest = URLRequest(url: URL(string: "htp://invalid.url")!)
        
        let expectation = XCTestExpectation(description: "Task should fail with network error")
        
        let task = Task {
            do {
                let _ = try await URLSession.shared.data(for: urlRequest)
                XCTFail("Expected network error, but got success")
            } catch {
                if (error as? URLError)?.code == .unsupportedURL {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected URLError.unsupportedURL, but got \(error)")
                }
            }
        }
        
        await fulfillment(of: [expectation], timeout: 10)
    }
    
    func testDataTaskCancellation() async throws {
        guard let url = URL(string: "https://apple.com") else { return }
        let urlRequest = URLRequest(url: url)
        
        let expectation = XCTestExpectation(description: "Task should be cancelled")

        let task = Task {
            do {
                _ = try await URLSession.shared.dataTask(for: urlRequest)
                XCTFail("Expected CancellationError, but got success")
            } catch is CancellationError {
                expectation.fulfill()
            } catch {
                XCTFail("Expected CancellationError, but got \(error)")
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now()) {
            task.cancel()
        }
        await fulfillment(of: [expectation], timeout: 10)
    }
}
