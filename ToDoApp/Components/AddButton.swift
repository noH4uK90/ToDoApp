//
//  AddButton.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/22/24.
//

import SwiftUI

struct AddButton: View {
    
    private var action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(
            action: { action() },
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
