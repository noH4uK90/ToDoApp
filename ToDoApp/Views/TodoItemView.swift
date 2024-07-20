//
//  ToDoItemView.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/21/24.
//

import SwiftUI

struct TodoItemView: View {
    @Binding var todo: TodoItem
    
    init(todo: Binding<TodoItem>) {
        _todo = todo
    }
    
    var body: some View {
        HStack {
            IsCompletedButton(isCompleted: todo.isCompleted, importance: todo.importance)
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "exclamationmark.2")
                        .symbolRenderingMode(.multicolor)
                        .fontWeight(.bold)
                        .isHidden(todo.importance != .important || todo.isCompleted, remove: true)
                    Text(todo.text)
                        .lineLimit(3)
                }
                HStack {
                    Image(systemName: "calendar")
                    Text(todo.expires ?? Date(), formatter: DateFormatter.prettyFormat(format: "dd LLLL"))
                }
                
                .isHidden(todo.expires == nil || todo.isCompleted, remove: true)
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            .foregroundStyle(todo.isCompleted ? .secondary : .primary)
            .strikethrough(todo.isCompleted, pattern: .solid, color: .secondary)
            
            Spacer()
            
            if let stringColor = todo.color {
                RoundedRectangle(cornerRadius: 35)
                    .fill(Color(hex: stringColor) ?? .clear)
                    .frame(width: 5)
                    .frame(maxHeight: .infinity)
            }
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimension in
            switch todo.isCompleted {
            case true:
                return viewDimension[.listRowSeparatorLeading]
            case false:
                return viewDimension[.listRowSeparatorLeading] - 20
            }
        }
        .padding(.vertical, 7)
    }
}

#Preview {
    HomeView()
}
