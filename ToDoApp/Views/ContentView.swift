//
//  ContentView.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/17/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ToDoListView()
                .navigationTitle("Мои дела")
        }
        .padding()
        .onAppear {
            let todo = TodoItem(text: "")
        }
    }
}

#Preview {
    ContentView()
}
