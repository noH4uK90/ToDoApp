//
//  DateCollectionViewCell.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/20/24.
//

import Foundation
import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    static let identifier = "DateCell"

    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .gray.withAlphaComponent(0.3) : .clear
            layer.borderWidth = isSelected ? 1.4 : 0
            layer.borderColor = .init(gray: 0, alpha: 0.3)
            layer.cornerRadius = 12
        }
    }

    func makeCell(text: String) {
        let text = text.split(separator: " ").joined(separator: "\n")
        let label = makeLabel(text: text)
        self.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
