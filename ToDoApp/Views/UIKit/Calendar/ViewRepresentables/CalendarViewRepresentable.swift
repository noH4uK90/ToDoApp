//
//  CalendarView.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/20/24.
//

import Foundation
import UIKit
import SwiftUI

struct CalendarViewRepresentable: UIViewControllerRepresentable {
    let viewModel = TodoListViewModel()

    func makeUIViewController(context: Context) -> some UIViewController {
        return CalendarViewController(viewModel: viewModel)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}
