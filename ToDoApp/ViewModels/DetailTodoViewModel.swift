//
//  ManageToDoViewModel.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/4/24.
//

import CocoaLumberjackSwift
import Foundation
import SwiftUI

extension DetailTodoView {
    @MainActor class ViewModel: ObservableObject {
        @Published var text: String = ""
        @Published var importance: Importance = .basic
        @Published var expiresDate: Date = Date().addingTimeInterval(24*3600)
        @Published var selectionColor: Color = .white
        @Published var brightness: CGFloat = 0.999
        
        @Published var isExpires: Bool = false
        @Published var isHasColor: Bool = false
        @Published var isShowDatePicker: Bool = false
        @Published var isShowColorPicker: Bool = false
        
        private var todo: TodoItem?
        private var onSave: (TodoItem) -> Void
        
        init(todo: TodoItem? = nil, onSave: @escaping (TodoItem) -> Void) {
            self.todo = todo
            if let todo = todo {
                self.text = todo.text
                self.importance = todo.importance
                if let expires = todo.expires {
                    self.isExpires = true
                    self.expiresDate = expires
                }
                if let color = todo.color {
                    self.isHasColor = true
                    self.selectionColor = Color(hex: color) ?? .clear
                }
            }
            self.onSave = onSave
        }
        
        func save() {
            if let todo = todo {
                DDLogInfo("Modify todo")
                self.todo = todo.modify(
                    text: text,
                    importance: importance,
                    expires: isExpires ? expiresDate : nil,
                    color: isShowColorPicker ? selectionColor.toHex() : nil
                )
            } else {
                DDLogInfo("Create new todo")
                self.todo = TodoItem(text: text, importance: importance, expires: isExpires ? expiresDate : nil, color: isShowColorPicker ? selectionColor.toHex() : nil)
            }
            
            if let todo = self.todo {
                onSave(todo)
            }
        }
    }
}
