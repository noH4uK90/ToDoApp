//
//  ManageToDoView.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/23/24.
//

import SwiftUI

struct DetailTodoView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.verticalSizeClass) var sizeClass
    
    @StateObject var viewModel: ViewModel
    
    private var lineLimit: Int {
        sizeClass == .regular ? 3 : 7
    }
    
    init(todo: TodoItem?, onSave: @escaping (TodoItem) -> Void) {
        _viewModel = StateObject(wrappedValue: ViewModel(todo: todo, onSave: onSave))
    }
    
    var body: some View {
        NavigationStack {
            form()
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
                            viewModel.save()
                            dismiss()
                        }
                    }
                }
        }
    }
    
    @ViewBuilder
    func form() -> some View {
        if sizeClass == .regular {
            Form {
                textSection
                detailsSection
                deleteButton
            }
        } else {
            HStack(spacing: 0) {
                Form {
                    textSection
                }
                
                Form {
                    detailsSection
                    deleteButton
                }
            }
        }
    }
    
    var textSection: some View {
        Section {
            TextField("Что надо сделать?", text: $viewModel.text, axis: .vertical)
                .lineLimit(lineLimit...)
        }
    }
    
    var detailsSection: some View {
        Section {
            importanceComponent
            expiresComponent
            colorComponent
        }
    }
    
    var deleteButton: some View {
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
    
    var importanceComponent: some View {
        HStack {
            Text("Важность")
            Spacer()
            ImportancePicker(importance: $viewModel.importance)
                .frame(width: 140)
        }
    }
    
    var expiresComponent: some View {
        Group {
            HStack {
                VStack(alignment: .leading) {
                    Text("Сделать до")
                    if viewModel.isExpires {
                        showDatePickerButton
                    }
                }
                Spacer()
                Toggle("", isOn: $viewModel.isExpires)
            }
            
            if viewModel.isShowDatePicker {
                DatePicker("", selection: $viewModel.expiresDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .environment(\.locale, Locale.init(identifier: Locale.preferredLanguages.first ?? "en-US"))
                    .transition(.slide)
            }
        }
    }
    
    var colorComponent: some View {
        Group {
            HStack {
                VStack(alignment: .leading) {
                    Text("Цвет")
                    if viewModel.isHasColor {
                        showColorPickerButton
                    }
                }
                Spacer()
                Toggle("", isOn: $viewModel.isHasColor)
            }
            
            if viewModel.isShowColorPicker {
                HStack {
                    ColorPicker(selectionColor: $viewModel.selectionColor, brightness: $viewModel.brightness)
                    Spacer()
                    Slider(sliderProgress: $viewModel.brightness, tint: $viewModel.selectionColor)
                }
                .frame(height: 200)
                .transition(.slide)
            }
        }
    }
    
    var showDatePickerButton: some View {
        Button(
            action: {
                withAnimation(.easeInOut) {
                    viewModel.isShowDatePicker.toggle()
                }
            },
            label: {
                Text(viewModel.expiresDate.toPretty(format: "dd MMMM yyyy"))
                    .font(.footnote)
                    .fontWeight(.bold)
            }
        )
    }
    
    var showColorPickerButton: some View {
        Button(
            action: {
                withAnimation(.easeInOut) {
                    viewModel.isShowColorPicker.toggle()
                }
            },
            label: {
                Text("#\(viewModel.selectionColor.toHex() ?? "")")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(hue: 1.0, saturation: 1, brightness: 1),
                                Color(hue: 0.9, saturation: 1, brightness: 1),
                                Color(hue: 0.8, saturation: 1, brightness: 1),
                                Color(hue: 0.7, saturation: 1, brightness: 1),
                                Color(hue: 0.6, saturation: 1, brightness: 1),
                                Color(hue: 0.5, saturation: 1, brightness: 1),
                                Color(hue: 0.4, saturation: 1, brightness: 1),
                                Color(hue: 0.3, saturation: 1, brightness: 1),
                                Color(hue: 0.2, saturation: 1, brightness: 1),
                                Color(hue: 0.1, saturation: 1, brightness: 1),
                                Color(hue: 0.0, saturation: 1, brightness: 1),
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
        )
    }
}

#Preview {
    HomeView()
}
