//
//  CalendarViewController.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/20/24.
//

import Foundation
import UIKit

class CalendarViewController: UIViewController {

    private var viewModel: TodoListViewModel
    private var dateCollectionViewController: DateCollectionViewController
    private var todoTableViewController: TodoTableViewController

    init(viewModel: TodoListViewModel) {
        self.viewModel = viewModel
        self.dateCollectionViewController = DateCollectionViewController(viewModel: viewModel)
        self.todoTableViewController = TodoTableViewController(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(dateCollectionViewController)
        addChild(todoTableViewController)

        view.addSubview(dateCollectionViewController.view)
        view.addSubview(todoTableViewController.view)

        setupConstraints()

        dateCollectionViewController.didMove(toParent: self)
        todoTableViewController.didMove(toParent: self)
    }
}

// MARK: Constraints
extension CalendarViewController {
    private func setupConstraints() {
        dateCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        todoTableViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dateCollectionViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dateCollectionViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dateCollectionViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dateCollectionViewController.view.heightAnchor.constraint(equalToConstant: 100),

            todoTableViewController.view.topAnchor.constraint(equalTo: dateCollectionViewController.view.bottomAnchor),
            todoTableViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todoTableViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            todoTableViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
