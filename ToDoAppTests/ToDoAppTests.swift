//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by Иван Спирин on 6/17/24.
//

import XCTest
@testable import ToDoApp

class TodoItemTests: XCTestCase {

    func testTodoItemInitialization() {
        let id = "DB5FEF23-DF9E-4286-BB16-DBC94A869FBA"
        let text = "Сделать что-то"
        let importance = Importance.important
        let expires = ISO8601DateFormatter().date(from: "2024-06-15T16:43:44Z")
        let isCompleted = false

        let todoItem = TodoItem(id: id, text: text, importance: importance, expires: expires, isCompleted: isCompleted)

        XCTAssertEqual(todoItem.id, id)
        XCTAssertEqual(todoItem.text, text)
        XCTAssertEqual(todoItem.importance, importance)
        XCTAssertEqual(todoItem.expires, expires)
        XCTAssertEqual(todoItem.isCompleted, isCompleted)
    }

    func testTodoItemInitializationWithDefaults() {
        let text = "Сделать что-то"

        let todoItem = TodoItem(id: nil, text: text, importance: nil, expires: nil, isCompleted: nil)

        XCTAssertEqual(todoItem.text, text)
        XCTAssertEqual(todoItem.importance, .usual)
        XCTAssertNil(todoItem.expires)
        XCTAssertFalse(todoItem.isCompleted)
    }

    func testTodoItemToJson() {
        let id = "DB5FEF23-DF9E-4286-BB16-DBC94A869FBA"
        let text = "Сделать что-то"
        let importance = Importance.important
        let expires = ISO8601DateFormatter().date(from: "2024-06-15T16:43:44Z")
        let isCompleted = false

        let todoItem = TodoItem(id: id, text: text, importance: importance, expires: expires, isCompleted: isCompleted)
        let json = todoItem.json as? [String: Any]

        XCTAssertNotNil(json)

        XCTAssertEqual(json?["id"] as? String, id)
        XCTAssertEqual(json?["text"] as? String, text)
        XCTAssertEqual(json?["isCompleted"] as? Bool, isCompleted)
        XCTAssertEqual(json?["importance"] as? String, importance.rawValue)
        XCTAssertEqual(json?["expires"] as? String, "2024-06-15T16:43:44Z")
    }

    func testTodoItemFromJson() {
        let json: [String: Any] = [
            "id": "DB5FEF23-DF9E-4286-BB16-DBC94A869FBA",
            "text": "Сделать что-то",
            "isCompleted": false,
            "importance": "Важная",
            "expires": "2024-06-15T16:43:44Z"
        ]
        
        let todoItem = TodoItem.parse(json: json)

        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.id, "DB5FEF23-DF9E-4286-BB16-DBC94A869FBA")
        XCTAssertEqual(todoItem?.text, "Сделать что-то")
        XCTAssertEqual(todoItem?.importance, .important)
        XCTAssertEqual(todoItem?.expires, ISO8601DateFormatter().date(from: "2024-06-15T16:43:44Z"))
        XCTAssertEqual(todoItem?.isCompleted, false)
    }

    func testTodoItemFromJsonWithoutImportanceAndExpires() {
        let json: [String: Any] = [
            "id": "DB5FEF23-DF9E-4286-BB16-DBC94A869FBA",
            "text": "Сделать что-то",
            "isCompleted": false,
        ]
        
        let todoItem = TodoItem.parse(json: json)

        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.id, "DB5FEF23-DF9E-4286-BB16-DBC94A869FBA")
        XCTAssertEqual(todoItem?.text, "Сделать что-то")
        XCTAssertEqual(todoItem?.importance, .usual)
        XCTAssertNil(todoItem?.expires)
        XCTAssertEqual(todoItem?.isCompleted, false)
    }

    func testTodoItemFromCSV() {
        let csvString = "DB5FEF23-DF9E-4286-BB16-DBC94A869FBA;Сделать что-то;false;Важная;2024-06-15T16:43:44Z"
        let todoItems = TodoItem.parseCSV(from: csvString, separator: ";")
        let todoItem = todoItems.first

        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.id, "DB5FEF23-DF9E-4286-BB16-DBC94A869FBA")
        XCTAssertEqual(todoItem?.text, "Сделать что-то")
        XCTAssertEqual(todoItem?.importance, .important)
        XCTAssertEqual(todoItem?.expires, ISO8601DateFormatter().date(from: "2024-06-15T16:43:44Z"))
        XCTAssertEqual(todoItem?.isCompleted, false)
    }
    
    func testTodoItemFromCSVWithSameSeparatorInText() {
        let csvString = "DB5FEF23-DF9E-4286-BB16-DBC94A869FBA;\"Сделать; что-то\";false;Важная;2024-06-15T16:43:44Z"
        let todoItems = TodoItem.parseCSV(from: csvString, separator: ";")
        let todoItem = todoItems.first
        
        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.id, "DB5FEF23-DF9E-4286-BB16-DBC94A869FBA")
        XCTAssertEqual(todoItem?.text, "Сделать; что-то")
        XCTAssertEqual(todoItem?.importance, .important)
        XCTAssertEqual(todoItem?.expires, ISO8601DateFormatter().date(from: "2024-06-15T16:43:44Z"))
        XCTAssertEqual(todoItem?.isCompleted, false)
    }
    
    func testTodoItemFromCSVWithOnlyText() {
        let csvString = ";\"Сделать; что-то\";;;"
        let todoItems = TodoItem.parseCSV(from: csvString, separator: ";")
        let todoItem = todoItems.first
        
        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.text, "Сделать; что-то")
        XCTAssertEqual(todoItem?.importance, .usual)
        XCTAssertNil(todoItem?.expires)
        XCTAssertEqual(todoItem?.isCompleted, false)
    }
    
    func testTodoItemFromCSVWithoutFields() {
        let csvString = ";;;;"
        let todoItems = TodoItem.parseCSV(from: csvString, separator: ";")
        
        XCTAssertTrue(todoItems.isEmpty)
    }
}
