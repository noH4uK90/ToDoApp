//
//  Date.extension.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/16/24.
//

import Foundation

extension Date {
    func toUnixTimestamp() -> Int64 {
        Int64(self.timeIntervalSince1970)
    }
    
    func toPretty(format: String = "dd MM yyyy") -> String {
        let dateFormatter = DateFormatter.prettyFormat(format: format)
        return dateFormatter.string(from: self)
    }
}
