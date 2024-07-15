//
//  Date.Extension.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/22/24.
//

import Foundation

extension DateFormatter {
    static func prettyFormat(format: String = "dd LL yyyy") -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "ru-RU"/*Locale.preferredLanguages.first ?? "en-US"*/)
        formatter.dateFormat = format
        return formatter
    }
}
