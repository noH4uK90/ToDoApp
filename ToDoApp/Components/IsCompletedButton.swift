//
//  IsCompletedButton.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/21/24.
//

import SwiftUI

struct IsCompletedButton: View {
    @Binding var isCompleted: Bool
    @Binding var importance: Importance
    
    init(isCompleted: Bool, importance: Importance) {
        _isCompleted = Binding<Bool>.constant(isCompleted)
        _importance = Binding<Importance>.constant(importance)
    }
    
    var body: some View {
        Circle()
            .fill(backgroundColor)
            .stroke(borderColor, lineWidth: 1.5)
            .frame(width: 24, height: 24)
            .overlay {
                Image(systemName: "checkmark")
                    .imageScale(.small)
                    .fontWeight(.bold)
                    .foregroundStyle(foregroundColor)
            }
    }
    
    var backgroundColor: Color {
        return isCompleted ? .green : (
            importance == .important ? .red.opacity(
                0.15
            ) : .clear
        )
    }
    
    var foregroundColor: Color {
        return isCompleted ? .white : .clear
    }
    
    var borderColor: Color {
        return isCompleted ? .clear : (
            importance == .important ? .red : .gray.opacity(
                0.4
            )
        )
    }
}

#Preview {
    IsCompletedButton(
//        isCompleted: Binding<Bool>.constant(false),
//        importance: Binding<Importance>.constant(.important)
        isCompleted: true,
        importance: .important
    )
}
