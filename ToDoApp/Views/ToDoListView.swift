//
//  ToDoList.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/21/24.
//

import SwiftUI

struct ToDoListView: View {
    @State var isShowSheet: Bool = false
    @State var selectedItem = 1
    var body: some View {
        List {
            Section {
                ForEach(0...30, id: \.self) { index in
                    ToDoItemView()
                }
            } header: {
                HStack {
                    Text("Выполнено")
                    Spacer()
                    Button("Показать") {
                        
                    }
                }
            }.textCase(nil)
        }
        .overlay(alignment: .bottom) {
            addButton
        }
        .sheet(isPresented: $isShowSheet) {
            ManageToDoView()
        }
    }
    
    var addButton: some View {
        Button(
            action: {
                isShowSheet.toggle()
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
