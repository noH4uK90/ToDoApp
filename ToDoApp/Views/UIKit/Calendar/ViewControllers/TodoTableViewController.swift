//
//  TodoTableViewController.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/20/24.
//

import Foundation
import UIKit

//class TodoTableViewController: UIViewController {
//
//    private var viewModel: TodoListViewModel
//
//    private lazy var table: UITableView = {
//        let table = UITableView(frame: .zero, style: .insetGrouped)
//        table.register(TodoTableHeader.self, forHeaderFooterViewReuseIdentifier: TodoTableHeader.identifier)
//        table.register(TodoTableCell.self, forCellReuseIdentifier: TodoTableCell.identifier)
//        table.dataSource = self
//        table.delegate = self
//        table.translatesAutoresizingMaskIntoConstraints = false
//        table.showsVerticalScrollIndicator = false
//        return table
//    }()
//
//    init(viewModel: TodoListViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(table)
//        setupConstraints()
//    }
//}

// MARK: Data source
extension CalendarViewController: UITableViewDataSource {
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
extension CalendarViewController: UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TodoTableHeader.identifier) as? TodoTableHeader
        let sortedKeys = Array(self.viewModel.todosGroupedByDate.keys).sorted()
        header?.textLabel?.text = sortedKeys[section]
        return header
    }
    
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == table {
            if let firstVisibleSection = table.indexPathsForVisibleRows?.first?.section {
                let indexPath = IndexPath(item: firstVisibleSection, section: 0)
//                collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
            }
        }
    }
}

// MARK: Constraints
extension CalendarViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
