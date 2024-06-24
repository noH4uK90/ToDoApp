//
//  ToDoItemView.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/21/24.
//

import SwiftUI

struct ToDoItemView: View {
    @State var isCompleted = false
    @State var importance: Importance = .important
    @State var expires: Date? = nil
    var body: some View {
        HStack {
            IsCompletedButton(isCompleted: $isCompleted, importance: $importance)
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "exclamationmark.2")
                        .symbolRenderingMode(.multicolor)
                        .fontWeight(.bold)
                        .isHidden(importance != .important || isCompleted, remove: true)
                    Text("Задача")
                        .lineLimit(3)
                }
                HStack {
                    Image(systemName: "calendar")
                    Text(expires ?? Date(), formatter: DateFormatter.prettyFormat(format: "dd LLLL"))
                }
                
                .isHidden(expires == nil || isCompleted, remove: true)
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            .foregroundStyle(isCompleted ? .secondary : .primary)
            .strikethrough(isCompleted, pattern: .solid, color: .secondary)
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimension in
            switch isCompleted {
            case true:
                return viewDimension[.listRowSeparatorLeading]
            case false:
                return viewDimension[.listRowSeparatorLeading] - 20
            }
        }
        .padding(.vertical, 7)
        .onTapGesture {
            withAnimation() {
                isCompleted.toggle()
            }
        }
        .swipeActions(edge: .leading) {
            completeButton
        }
        .swipeActions(edge: .trailing) {
            deleteButton
        }
        .swipeActions(edge: .trailing) {
            infoButton
        }
    }
    
    var completeButton: some View {
        Button(
            action: {},
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
    
    var deleteButton: some View {
        Button(
            action: {},
            label: {
                Image(systemName: "trash.fill")
            }
        )
        .tint(.red)
    }
    
    var infoButton: some View {
        Button(
            action: {},
            label: {
                Image(systemName: "info.circle.fill")
            }
        )
    }}

#Preview {
    HomeView()
}
