//
//  Int.Extension.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/16/24.
//

import Foundation

extension Int64 {
    func toDate() -> Date {
        Date(timeIntervalSince1970: TimeInterval(self))
    }
}
