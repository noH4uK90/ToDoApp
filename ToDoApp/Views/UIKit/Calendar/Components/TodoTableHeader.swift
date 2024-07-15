//
//  TodoTableHeader.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/15/24.
//

import Foundation
import UIKit

class TodoTableHeader: UITableViewHeaderFooterView {
    static let identifier = "TodoTableHeader"
    
    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        return label
    }
    
    func makeHeader(text: String) {
        let label = makeLabel(text: text)
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
