//
//  CalendarViewController.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/14/24.
//

import UIKit
import SwiftUI

struct CalendarView: UIViewControllerRepresentable {
    let viewModel = TodoListViewModel()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return CalendarViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
