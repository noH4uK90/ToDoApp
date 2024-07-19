//
//  ImportancePicker.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/22/24.
//

import SwiftUI

struct ImportancePicker: View {
    @Binding var importance: Importance
    
    var body: some View {
        Picker("", selection: $importance) {
            Image(systemName: "arrow.down")
                .tag(Importance.low)
            Text("нет")
                .tag(Importance.basic)
            Text("‼")
                .tag(Importance.important)
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    ImportancePicker(
        importance: Binding<Importance>.constant(
            .basic
        )
    )
}
