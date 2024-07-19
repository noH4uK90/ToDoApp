//
//  ElementResponse.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/17/24.
//

import Foundation

struct ElementResponse<TItem: Codable>: Codable {
    let status: String
    let element: TItem
    let revision: Int32
}
