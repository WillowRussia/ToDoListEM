//
//  NetworkToDo.swift
//  ToDoListEM
//
//  Created by Илья Востров on 28.08.2025.
//

import Foundation

struct APIResponse: Codable {
    let todos: [NetworkToDo]
    let total: Int
    let skip: Int
    let limit: Int
}

struct NetworkToDo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
