//
//  ManageToDoView.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/23/24.
//

import SwiftUI

struct ManageToDoView: View {
    @Environment(\.dismiss) var dismiss
    @State var importance: Importance = .usual
    @State var isExpires: Bool = false
    @State var selectedDate: Date = Date().addingTimeInterval(24*3600)
    @State var isShowDatePicker: Bool = false
    @State var text: String = ""
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Что надо сделать?", text: $text, axis: .vertical)
                        .lineLimit(3...)
                }
                
                Section {
                    VStack {
                        importanceSection
                            .animation(nil)
                        Divider()
                            .animation(nil)
                        expiresSection
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button(
                            role: .destructive,
                            action: {
                            },
                            label: {
                                Text("Удалить")
                            })
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Дело")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отменить") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        
                    }
                }
            }
            .onChange(of: isExpires) { value in
                withAnimation(.easeInOut(duration: 1)) {
                    isShowDatePicker = value
                }
            }
        }
        .animation(.easeInOut)
    }
    
    var importanceSection: some View {
        HStack {
            Text("Важность")
            Spacer()
            ImportancePicker(importance: $importance)
                .frame(width: 140)
        }
    }
    
    var expiresSection: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Сделать до")
                    if isExpires {
                        showDatePickerButton
                    }
                }
                Spacer()
                Toggle("", isOn: $isExpires)
            }
            .animation(nil)
            
            if isShowDatePicker {
                Divider()
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .environment(\.locale, Locale.init(identifier: Locale.preferredLanguages.first ?? "en-US"))
                    .transition(
                        .slide
//                        .opacity.combined(with: .move(edge: .top))
                    )
                    .animation(.easeInOut)
            }
        }
    }
    
    var showDatePickerButton: some View {
        Button(
            action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isShowDatePicker.toggle()
                }
            },
            label: {
                let text = DateFormatter.prettyFormat(format: "dd LLLL yyyy").string(from: selectedDate)
                Text(text)
                    .font(.footnote)
                    .fontWeight(.bold)
            }
        )
    }
}

#Preview {
    ManageToDoView()
}
