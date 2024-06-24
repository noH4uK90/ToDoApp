//
//  ContentView.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/17/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ToDoListView()
                .navigationTitle("Мои дела")
        }
        .onAppear {
            let todo = TodoItem(text: "")
        }
    }
}

#Preview {
    HomeView()
}
