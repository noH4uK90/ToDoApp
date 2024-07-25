//
//  ToDoList.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/21/24.
//

import SwiftUI

struct TodoListView_iOS: View {
    @State var isShowSheet: Bool = false
    
    @StateObject var viewModel: TodoListViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: TodoListViewModel())
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach($viewModel.todos, id: \.id) { $todo in
                        TodoItemView(todo: $todo)
                            .onTapGesture {
                                withAnimation() {
                                    viewModel.complete(id: todo.id)
                                }
                            }
                            .swipeActions(edge: .leading) {
                                completeButton(id: todo.id)
                            }
                            .swipeActions(edge: .trailing) {
                                deleteButton(id: todo.id)
                            }
                            .swipeActions(edge: .trailing) {
                                infoButton(todo: todo)
                            }
                    }
                } header: {
                    header
                }.textCase(nil)
            }
            .overlay(alignment: .bottom) {
                AddButton {
                    viewModel.selectedTodo = nil
                    isShowSheet.toggle()
                }
            }
            .sheet(isPresented: $isShowSheet) {
                DetailTodoView(todo: viewModel.selectedTodo, onSave: { todo in
                    viewModel.saveTodo(todo: todo)
                })
            }
            .navigationTitle("Мои дела")
            .toolbar {
                if viewModel.isActive {
                    ToolbarItem(placement: .topBarLeading) {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: CalendarView(), label: {
                        Image(systemName: "calendar")
                    })
                }
            }
        }
    }
    
    var header: some View {
        HStack {
            Text("Выполнено - \(viewModel.completedCount)")
            Spacer()
            Button("Показать") {
                
            }
        }
    }
    
    @ViewBuilder
    func completeButton(id: String) -> some View {
        Button(
            action: {
                viewModel.complete(id: id)
            },
            label: {
                Image(systemName: "checkmark.circle")
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.green)
                    .background(.white)
                    .imageScale(.large)
                    .fontWeight(.bold)
            }
        )
        .tint(.green)
    }
    
    @ViewBuilder
    func deleteButton(id: String) -> some View {
        Button(
            action: {
                viewModel.delete(id: id)
            },
            label: {
                Image(systemName: "trash.fill")
            }
        )
        .tint(.red)
    }
    
    @ViewBuilder
    func infoButton(todo: TodoItem) -> some View {
        Button(
            action: {
                viewModel.selectedTodo = todo
                isShowSheet = true
            },
            label: {
                Image(systemName: "info.circle.fill")
            }
        )
    }
}

#Preview {
    HomeView()
}
