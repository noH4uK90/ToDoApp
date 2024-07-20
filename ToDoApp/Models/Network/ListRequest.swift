//
//  ListRequest.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/19/24.
//

import Foundation

struct ListRequest<TItem: Sendable & Codable>: Sendable, Codable {
    let list: [TItem]
}
