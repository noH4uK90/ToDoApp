//
//  TodoTableCell.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/20/24.
//

import Foundation
import UIKit
import SwiftUI

class TodoTableCell: UITableViewCell {
    static let identifier = "TodoTableCell"

    private lazy var circle: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        view.layer.cornerRadius = view.bounds.size.width/2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func prepareForReuse() {
        textLabel?.attributedText = nil
        circle.removeFromSuperview()
    }

    func makeCell(todo: TodoItem) {
        self.addSubview(circle)
        setupConstraints()

        if todo.isCompleted {
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
            let attributedText = NSAttributedString(string: todo.text, attributes: attributes)
            textLabel?.attributedText = attributedText
            textLabel?.textColor = .gray
            circle.backgroundColor = .clear
        } else {
            textLabel?.text = todo.text
            textLabel?.textColor = .label
            if let color = todo.color {
                circle.backgroundColor = UIColor(Color(hex: color) ?? .clear)
            } else {
                circle.backgroundColor = .clear
            }
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            circle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            circle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            circle.widthAnchor.constraint(equalToConstant: 15),
            circle.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
}
