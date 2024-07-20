//
//  String.Extension.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/20/24.
//

import Foundation

extension String {
    func toDate(from format: String = "dd MM yyyy") -> Date? {
        let dateFormatter = DateFormatter.prettyFormat(format: format)
        return dateFormatter.date(from: self)
    }
}
