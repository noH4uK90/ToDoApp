//
//  TodoListView.iPadOS.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/8/24.
//

import SwiftUI

struct TodoListView_iPadOS: View {
    @StateObject var viewModel: TodoListViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: TodoListViewModel())
    }
    
    var body: some View {
        NavigationSplitView(
            sidebar: {
                List(selection: $viewModel.selectedTodo) {
                    Section {
                        ForEach($viewModel.todos) { todo in
                            NavigationLink(value: todo.wrappedValue, label: {
                                TodoItemView(todo: todo)
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
                                        infoButton(todo: todo.wrappedValue)
                                    }
                            })
                        }
                    } header: {
                        header
                    }
                }
                .overlay(alignment: .bottom) {
                    AddButton {
                        viewModel.selectedTodo = nil
                    }
                }
                .navigationTitle("Мои дела")
            },
            detail: {
                if let todo = viewModel.selectedTodo {
                    DetailTodoView(todo: todo, onSave: { todo in
                        viewModel.saveTodo(todo: todo)
                    })
                } else {
                    DetailTodoView(todo: nil, onSave: { todo in
                        viewModel.saveTodo(todo: todo)
                    })
                }
            }
        )
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
            },
            label: {
                Image(systemName: "info.circle.fill")
            }
        )
    }
}

#Preview {
    TodoListView_iPadOS()
}
