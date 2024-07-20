//
//  ElementRequest.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/19/24.
//

import Foundation

struct ElementRequest<TItem: Sendable & Codable>: Sendable, Codable {
    let element: TItem
}
