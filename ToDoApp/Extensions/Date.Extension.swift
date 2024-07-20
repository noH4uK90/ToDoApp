//
<<<<<<< HEAD
//  Date.Extension.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/14/24.
=======
//  Date.extension.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/16/24.
>>>>>>> c4df29bfdebdafea36fb37b547d3ecb9dd2a32ca
//

import Foundation

extension Date {
<<<<<<< HEAD
    func toPretty(format: String = "dd MM yyyy") -> String {
        let dateFormatter = DateFormatter.prettyFormat(format: format)
        return dateFormatter.string(from: self)
    }}
    func toUnixTimestamp() -> Int64 {
        Int64(self.timeIntervalSince1970)
    }
}
