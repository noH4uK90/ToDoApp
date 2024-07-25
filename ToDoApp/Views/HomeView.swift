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
//        NavigationStack {
//            CalendarView()
//                .navigationTitle("Мои дела")
//                .navigationBarTitleDisplayMode(.inline)
//                .edgesIgnoringSafeArea(.bottom)
//                .overlay(alignment: .bottom) {
//                    addButton
//                }
//        }
    }
    
    var addButton: some View {
        Button(
            action: {
//                viewModel.selectedTodo = nil
//                isShowSheet.toggle()
            },
            label: {
                Image(systemName: "plus")
                    .fontWeight(.bold)
                    .imageScale(.large)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Color(UIColor.systemBlue).shadow(.drop(color: .black.opacity(0.25), radius: 7, x: 0, y: 10)), in: .circle)
                    .frame(width: 44, height: 44)
            }
        )
    }
}

#Preview {
    HomeView()
}
