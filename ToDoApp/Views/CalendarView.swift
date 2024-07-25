//
//  CalendarView.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/22/24.
//

import SwiftUI

struct CalendarView: View {
    
    @State private var isShowSheet = false
    
    var body: some View {
        CalendarViewRepresentable()
            .ignoresSafeArea(.all, edges: .bottom)
            .overlay(alignment: .bottom) {
                AddButton {
                    isShowSheet.toggle()
                }
            }
            .sheet(isPresented: $isShowSheet) {
                DetailTodoView(todo: nil, onSave: { todo in
                    
                })
            }
            .navigationTitle("Мои дела")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CalendarView()
}
