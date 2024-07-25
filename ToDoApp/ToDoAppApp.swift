//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/17/24.
//

import SwiftUI
import CocoaLumberjack
import FileCacheLibrary

@main
struct ToDoAppApp: App {
    
    private let todos: [TodoItem] = [
        TodoItem(
            text: "Купить продукты",
            importance: .basic,
            expires: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            isCompleted: false,
            createdDate: Date(),
            changedDate: nil,
            color: "#FF5733"
        ),
        TodoItem(
            text: "Позвонить маме",
            importance: .important,
            expires: Calendar.current.date(byAdding: .hour, value: 2, to: Date()),
            isCompleted: false,
            createdDate: Date(),
            changedDate: nil,
            color: "#33FF57"
        ),
        TodoItem(
            text: "Завершить проект",
            importance: .important,
            expires: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
            isCompleted: false,
            createdDate: Date(),
            changedDate: nil,
            color: "#3357FF"
        ),
        TodoItem(
            text: "Прочитать книгу",
            importance: .low,
            expires: nil,
            isCompleted: false,
            createdDate: Date(),
            changedDate: nil,
            color: "#FF33A1"
        ),
        TodoItem(
            text: "Сходить в спортзал",
            importance: .basic,
            expires: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            isCompleted: true,
            createdDate: Date(),
            changedDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            color: "#A133FF"
        ),
        TodoItem(
            text: "Сходить в спортзал 2",
            importance: .basic,
            expires: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            isCompleted: true,
            createdDate: Date(),
            changedDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            color: "#A133FF"
        ),
        TodoItem(
            text: "Написать отчет",
            importance: .important,
            expires: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
            isCompleted: false,
            createdDate: Date(),
            changedDate: nil,
            color: "#FF5733"
        ),
        TodoItem(
            text: "Сделать домашнее задание",
            importance: .basic,
            expires: Calendar.current.date(byAdding: .day, value: 5, to: Date()),
            isCompleted: false,
            createdDate: Date(),
            changedDate: nil,
            color: "#33FF57"
        ),
        TodoItem(
            text: "Позвонить другу",
            importance: .low,
            expires: Calendar.current.date(byAdding: .hour, value: 4, to: Date()),
            isCompleted: false,
            createdDate: Date(),
            changedDate: nil,
            color: "#3357FF"
        ),
        TodoItem(
            text: "Пойти на встречу",
            importance: .important,
            expires: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            isCompleted: false,
            createdDate: Date(),
            changedDate: nil,
            color: "#FF33A1"
        ),
        TodoItem(
            text: "Сделать уборку",
            importance: .basic,
            expires: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            isCompleted: true,
            createdDate: Date(),
            changedDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            color: "#A133FF"
        ),
        TodoItem(
            text: "Пойти на пробежку",
            importance: .low,
            expires: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
            isCompleted: false,
            createdDate: Date(),
            changedDate: nil,
            color: "#FF5733"
        ),
        TodoItem(
            text: "Посмотреть фильм",
            importance: .low,
            expires: nil,
            isCompleted: false,
            createdDate: Date(),
            changedDate: nil,
            color: "#33FF57"
        ),
        TodoItem(
            text: "Сходить к врачу",
            importance: .important,
            expires: Calendar.current.date(byAdding: .day, value: 4, to: Date()),
            isCompleted: false,
            createdDate: Date(),
            changedDate: nil,
            color: "#3357FF"
        ),
        TodoItem(
            text: "Купить подарок",
            importance: .basic,
            expires: Calendar.current.date(byAdding: .day, value: 6, to: Date()),
            isCompleted: false,
            createdDate: Date(),
            changedDate: nil,
            color: "#FF33A1"
        ),
        TodoItem(
            text: "Сделать резервное копирование",
            importance: .important,
            expires: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            isCompleted: false,
            createdDate: Date(),
            changedDate: nil,
            color: "#A133FF"
        )
    ]

    
    init() {
        DDLog.add(DDOSLogger.sharedInstance)
        do {
            let fileCache = FileCacheLibrary<TodoItem>()
            try fileCache.saveToFile(todos)
        } catch {
            print("Error \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
