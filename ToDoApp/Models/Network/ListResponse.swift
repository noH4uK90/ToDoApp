//
//  ListResponse.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/17/24.
//

import Foundation

struct ListResponse<TItem: Codable>: Codable {
    let status: String
    let list: [TItem]
    let revision: Int32
}
