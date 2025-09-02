//
//  ToDoViewInput.swift
//  ToDoListEM
//
//  Created by Илья Востров on 28.08.2025.
//


protocol ToDoViewInput: AnyObject {
    func reloadTableView()
    func showError(_ message: String)
}