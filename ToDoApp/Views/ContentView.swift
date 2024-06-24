//
//  ContentView.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/17/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            let todo = TodoItem(text: "Что; надо сделать")
            let fileCache = FileCache()
            print(Bool("false"))
            fileCache.createTodo(todo)
            fileCache.saveToFile(to: "todos", extension: .csv)
            fileCache.removeAll()
            fileCache.exportFromFile(from: "todos", extension: .csv)
            print(fileCache.todos)
        }
    }
}

#Preview {
    ContentView()
}
