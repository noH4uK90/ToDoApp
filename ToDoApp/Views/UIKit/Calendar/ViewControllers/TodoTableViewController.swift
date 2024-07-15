//
//  TodoTableViewController.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/15/24.
//

import Foundation
import UIKit
import SwiftUI

class TodoTableViewController: UIViewController {
    
    private var viewModel: TodoListViewModel
    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.register(TodoTableHeader.self, forHeaderFooterViewReuseIdentifier: TodoTableHeader.identifier)
        table.register(TodoTableCell.self, forCellReuseIdentifier: TodoTableCell.identifier)
        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    init(viewModel: TodoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(table)
        setupConstraints()
    }
}

// MARK: Data source
extension TodoTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.todosGroupedByDate.keys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sortedKeys = Array(self.viewModel.todosGroupedByDate.keys).sorted()
        let dateKey = sortedKeys[section]
        return self.viewModel.todosGroupedByDate[dateKey]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: TodoTableCell.identifier, for: indexPath) as? TodoTableCell else {
            return UITableViewCell()
        }
        
        let sortedKeys = Array(self.viewModel.todosGroupedByDate.keys).sorted()
        let dateKey = sortedKeys[indexPath.section]
        
        if let todosForDate = self.viewModel.todosGroupedByDate[dateKey] {
            let todo = todosForDate[indexPath.row]
            cell.makeCell(todo: todo)
        }
        
        return cell
    }
}

// MARK: Delegate
extension TodoTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let doneAction = makeAction(isLeading: true, indexPath: indexPath, tableView: tableView)
        doneAction.image = UIImage(systemName: "checkmark.circle")
        doneAction.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [doneAction])
        return configuration
    }
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let unreadyAction = makeAction(isLeading: false, indexPath: indexPath, tableView: tableView)
        unreadyAction.image = UIImage(systemName: "checkmark.circle.badge.xmark")
        unreadyAction.backgroundColor = .systemGray
        let configuration = UISwipeActionsConfiguration(actions: [unreadyAction])
        return configuration
    }
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        guard let header = view as? UITableViewHeaderFooterView else { return }
//        if let currentText = header.textLabel?.text {
//            header.textLabel?.text = currentText == "ДРУГОЕ" ? currentText.capitalized : currentText.lowercased()
//            header.textLabel?.font = .systemFont(ofSize: 16)
//        }
//    }
    func makeAction(isLeading: Bool, indexPath: IndexPath, tableView: UITableView) -> UIContextualAction {
        return UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            let sortedKeys = Array(self.viewModel.todosGroupedByDate.keys).sorted()
            let dateKey = sortedKeys[indexPath.section]
            if let todosForDate = self.viewModel.todosGroupedByDate[dateKey] {
                let todo = todosForDate[indexPath.row]
                let isCompleted = isLeading ? !todo.isCompleted : todo.isCompleted
                if isCompleted {
                    self.viewModel.complete(id: todo.id)
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
                completionHandler(true)
            }
        }
    }
}

// MARK: Constraints
extension TodoTableViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

#Preview {
    HomeView()
}
