//
//  Date.Extension.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/14/24.
//

import Foundation

extension Date {
    func toPretty(format: String = "dd MM yyyy") -> String {
        let dateFormatter = DateFormatter.prettyFormat(format: format)
        return dateFormatter.string(from: self)
    }}
