//
//  ContentView.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/17/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            TodoListView_iOS()
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            TodoListView_iPadOS()
        }
    }
}

#Preview {
    HomeView()
}
